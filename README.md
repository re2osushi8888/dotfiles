# dotfiles

## 対応環境

| 環境 | フラグ | コマンド |
|------|--------|---------|
| macOS (Apple Silicon) | `#mac` | `home-manager switch --flake ~/dotfiles#mac` |
| WSL2 (Ubuntu) | `#wsl` | `home-manager switch --flake ~/dotfiles#wsl` |

---

## セットアップ

### 1. Nix のインストール

[Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) を使う。flakes が最初から有効になる。

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

新しいターミナルを開いて確認。

```bash
nix --version
```

### 2. dotfiles を clone

```bash
cd ~
git clone https://github.com/re2osushi8888/dotfiles.git
```

### 3. 既存のファイルを削除

home-manager が管理するファイルと競合するため削除する。

```bash
rm ~/.zshrc ~/.zprofile ~/.gitconfig
```

### 4. home-manager を適用

**macOS:**
```bash
cd ~/dotfiles
nix run home-manager/master -- switch --flake .#mac
```

**WSL2 (Ubuntu):**
```bash
# zsh と git が必要
sudo apt update && sudo apt install -y zsh git

cd ~
# 上記 1〜3 を実施後
nix run home-manager/master -- switch --flake .#wsl
```

---

## 日常的な使い方

### 設定を反映する

```bash
hms   # home-manager switch（環境ごとのフラグは自動）
hmd   # ドライラン（変更確認のみ）
```

### パッケージを追加する

```bash
# 1. nix/home/common.nix の home.packages に追加
#    環境固有のパッケージは nix/home/mac.nix または nix/home/wsl.nix に追加

# 2. 反映
hms
```

パッケージ名は https://search.nixos.org/packages で検索。

### nixpkgs を更新する

```bash
nix flake update   # flake.lock を更新
hms                # 反映
```

### ロールバック

```bash
home-manager generations   # 世代一覧
home-manager rollback      # 1つ前に戻す
```

---

## 構成

```
nix/
└── home/
    ├── common.nix   # 全環境共通（git, neovim, zsh 等）
    ├── mac.nix      # macOS 固有
    └── wsl.nix      # WSL2 固有
```

| 設定 | ファイル |
|------|---------|
| 共通パッケージ・git・zsh | `nix/home/common.nix` |
| macOS 固有設定 | `nix/home/mac.nix` |
| WSL 固有設定 | `nix/home/wsl.nix` |
| mise (rust, ghcup) | mise のまま管理 |
