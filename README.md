# dotfiles

## セットアップ方法

WSL2 の Ubuntu を想定。前提として `zsh` と `git` がインストールされていること。

---

## Nix を使ったセットアップ（推奨）

パッケージ管理・dotfiles のシンボリックリンク・各種設定を home-manager で一括管理する。

### 1. Nix のインストール

[Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) を使うと flakes が最初から有効になる。

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. dotfiles を clone

```bash
cd ~
git clone https://github.com/re2osushi8888/dotfiles.git
```

### 3. 既存のシンボリックリンクを削除

home-manager が管理するファイルと競合するため削除する。

```bash
rm ~/.zshrc ~/.zprofile ~/.gitconfig
```

### 4. home-manager を適用

```bash
cd ~/dotfiles
nix run home-manager/master -- switch --flake .#r-yamamoto
```

### 5. 以降の更新

設定を変更したら以下を実行。

```bash
home-manager switch --flake .#r-yamamoto
```

### 管理構成

| 設定 | 管理方法 |
|------|----------|
| パッケージ (`ripgrep`, `neovim` など) | `nix/home.nix` の `home.packages` |
| dotfiles のシンボリックリンク | `home.file` + `mkOutOfStoreSymlink` |
| git 設定 | `programs.git` |
| zsh 設定 | `programs.zsh` |
| mise (rust, ghcup, claude) | mise のまま管理 |


## Nix の日常的な使い方

### パッケージを追加する

```bash
# 1. nix/home.nix の home.packages に追加
#    home.packages = with pkgs; [ bat ];

# 2. 反映
hms
```

パッケージ名は https://search.nixos.org/packages で検索。

### 設定を更新する

```bash
# nix/home.nix を編集後
hms          # 反映
hmd          # ドライラン（変更確認のみ）
```

### nixpkgs を最新に更新する

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

## おまけ：zsh のインストール・反映

```bash
sudo apt update
sudo apt install -y zsh
chsh -s "$(which zsh)"
```
