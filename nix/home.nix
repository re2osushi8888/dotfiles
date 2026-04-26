{ config, pkgs, ... }:

{
  home = {
    username = "re2";
    homeDirectory = "/home/re2";
    stateVersion = "25.05";

    sessionPath = [
      "$HOME/bin"
    ];

    # mise で管理していたツールを nix packages に移行
    # 残すもの(mise): rust, ghcup, claude (nixpkgs 未対応 or toolchain管理が複雑なもの)
    packages = with pkgs; [
      # シェルツール
      sheldon   # zsh プラグインマネージャ
      mise      # rust/ghcup/claude 用に残す

      # 検索・ナビゲーション
      ripgrep
      fd
      ghq
      bat

      # ターミナル
      zellij
      glow       # markdown ビューア

      # 開発ツール
      neovim
      lazygit
      delta      # git diff viewer
      stylua     # Lua フォーマッタ

      # CLI
      gh           # GitHub CLI
      jq
      claude-code

      # シェルプロンプト
      starship

      # 基本
      curl
      htop
    ];

    # stow の代わりに home.file でシンボリックリンク管理
    # mkOutOfStoreSymlink: nix store 外のファイルへのリンク (編集可能)
    file = {
      ".aliases".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/.aliases";
      ".config/sheldon".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/.config/sheldon";
      ".config/starship.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/.config/starship.toml";
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/.config/nvim";
      ".config/wezterm".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/.config/wezterm";
      ".config/mise/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/.config/mise/config.toml";
    };
  };

  programs = {
    home-manager.enable = true;

    # git 設定 (.gitconfig を home-manager が管理)
    git = {
      enable = true;
      settings = {
        user.name  = "re2osushi8888";
        user.email = "re.2osushi8888@gmail.com";
        alias = {
          a       = "add";
          aa      = "add -A";
          br      = "branch";
          cm      = "commit -m";
          st      = "status -sb";
          sw      = "switch";
          swc     = "switch -c";
          lg      = "log --oneline --graph --decorate";
          lga     = "log --oneline --graph --decorate --all";
          undo    = "reset --soft HEAD^";
          unstage = "restore --staged";
          discard = "restore";
          amend   = "commit --amend";
          d       = "diff";
          ds      = "diff --staged";
        };
        credential."https://github.com".helper      = "!gh auth git-credential";
        credential."https://gist.github.com".helper = "!gh auth git-credential";
        diff.tool          = "nvimdiff";
        difftool.prompt    = false;
        "difftool \"nvimdiff\"".cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
        pager = {
          diff    = "delta";
          log     = "delta";
          reflog  = "delta";
          show    = "delta";
        };
        core.pager               = "delta";
        interactive.diffFilter   = "delta --color-only";
        delta = {
          navigate     = true;
          line-numbers = true;
          side-by-side = true;
        };
        # ghq の root は複数指定 (リストで書くと重複キーになる)
        ghq.root = [ "~/work" "~/repos" ];
        "ghq \"https://github.com/re2osushi8888\"".root = "~/repos/";
        "includeIf \"gitdir:~/work/\"".path = "~/work/.gitconfig";
      };
    };

    # fzf (zsh integration は home-manager が自動追加)
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # direnv (ディレクトリごとの環境変数 / nix devShell の自動ロード)
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;  # nix devShell をキャッシュして高速化
    };

    # zsh (.zshrc / .zprofile を home-manager が管理)
    zsh = {
      enable = true;

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        hms = "home-manager switch --flake ~/dotfiles#re2osushi8888";
        hmd = "home-manager switch --flake ~/dotfiles#re2osushi8888 --dry-run";
      };

      # .zprofile 相当: 非インタラクティブシェル向け PATH 設定
#      profileExtra = ''
#       eval "$(mise activate zsh --shims)"
#     '';

      # .zshrc 相当
      initContent = ''
        bindkey -e

        # WezTerm shell integration
        source "$HOME/.config/wezterm/wezterm.sh"

        # mise (インタラクティブ用)
        eval "$(mise activate zsh)"

        # sheldon でプラグイン読み込み
        eval "$(sheldon source)"

        # starship プロンプト
        eval "$(starship init zsh)"

        # Haskell (ghcup)
        [ -d "$HOME/.ghcup/bin" ] && export PATH="$HOME/.ghcup/bin:$PATH"

        # エイリアス
        if [ -f ~/.aliases ]; then
          source ~/.aliases
        fi

        # git alias を g<name> でも呼べるようにする
        if command -v git >/dev/null 2>&1; then
          for alias in $(git config --get-regexp '^alias\.' | sed 's/^alias\.\([^ ]*\) .*/\1/'); do
            alias g''${alias}="git ''${alias}"
          done
        fi
      '';
    };
  };
}
