# dotfiles

## 対応環境

| 環境 | フラグ | コマンド |
|------|--------|---------|
| macOS (Apple Silicon) | `#mac` | `sudo darwin-rebuild switch --flake ~/dotfiles#mac` |
| WSL2 (Ubuntu) | `#wsl` | `home-manager switch --flake ~/dotfiles#wsl` |

---

## macOS セットアップ

### 1. Homebrew のインストール

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

インストール後、表示される `Next steps` の指示に従って PATH を通す（`~/.zprofile` への追記）。

```bash
# Apple Silicon の場合
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Nix のインストール

[Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) を使う。flakes が最初から有効になる。

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

新しいターミナルを開いて確認。

```bash
nix --version
```

### 3. dotfiles を clone

```bash
git clone https://github.com/re2osushi8888/dotfiles.git ~/dotfiles
```

### 4. 既存のファイルを削除

nix-darwin / home-manager が管理するファイルと競合するため削除する。

```bash
rm -f ~/.zshrc ~/.zprofile ~/.gitconfig
```

### 5. nix-darwin を適用

初回のみ `nix run` で bootstrap する。

```bash
cd ~/dotfiles
sudo nix run nix-darwin -- switch --flake .#mac
```

次回以降は `hms` エイリアスで適用できる。

```bash
hms   # sudo darwin-rebuild switch --flake ~/dotfiles#mac
```

---

## WSL2 (Ubuntu) セットアップ

### 1. 必要パッケージのインストール

```bash
sudo apt update && sudo apt install -y zsh git curl
```

### 2. Nix のインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. dotfiles を clone

```bash
git clone https://github.com/re2osushi8888/dotfiles.git ~/dotfiles
```

### 4. 既存のファイルを削除

```bash
rm -f ~/.zshrc ~/.gitconfig
```

### 5. home-manager を適用

```bash
cd ~/dotfiles
nix run home-manager/master -- switch --flake .#wsl
```

次回以降は `hms` エイリアスで適用できる。

```bash
hms   # home-manager switch --flake ~/dotfiles#wsl
```

---

## 日常的な使い方

### 設定を反映する

```bash
hms   # 設定を適用
hmd   # ドライラン（変更確認のみ）
```

### パッケージを追加する

```bash
# 1. nix/home/common.nix の home.packages に追加
#    環境固有のパッケージは nix/home/mac.nix または nix/home/wsl.nix に追加
#    macOS の GUI アプリは nix/system/darwin.nix の homebrew.casks に追加

# 2. 反映
hms
```

パッケージ名は https://search.nixos.org/packages で検索。

### nixpkgs を更新する

```bash
nix flake update   # flake.lock を更新
hms                # 反映
```

### ユーザー名を変更する

`flake.nix` の先頭の変数を変えるだけで全体に反映される。

```nix
macUser = "newname";
wslUser = "newname";
```

---

## 構成

```
dotfiles/
├── flake.nix              # エントリポイント（macUser / wslUser を定義）
├── nix/
│   ├── system/
│   │   └── darwin.nix     # macOS システム設定・Homebrew casks
│   └── home/
│       ├── common.nix     # 全環境共通（git, neovim, zsh 等）
│       ├── mac.nix        # macOS 固有（homeDirectory, エイリアス）
│       └── wsl.nix        # WSL2 固有（homeDirectory, エイリアス）
└── config/                # 各ツールの設定ファイル（symlink で管理）
```

| 設定 | ファイル |
|------|---------|
| 共通パッケージ・git・zsh | `nix/home/common.nix` |
| macOS GUI アプリ (Homebrew) | `nix/system/darwin.nix` |
| macOS 固有設定 | `nix/home/mac.nix` |
| WSL 固有設定 | `nix/home/wsl.nix` |
