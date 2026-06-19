{ config, pkgs, username, ... }:

{
  home = {
    username = username;
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
      eza

      # ターミナル
      zellij
      glow       # markdown ビューア

      # 開発ツール
      lazygit
      delta      # git diff viewer
      stylua     # Lua フォーマッタ
      tree-sitter
      neovim
      lua-language-server         # lua_ls
      typescript-language-server  # ts_ls
      prisma-language-server      # primals

      # CLI
      duti         # macOS デフォルトアプリ設定
      gh           # GitHub CLI
      jq
      claude-code
      cursor-cli

      # シェルプロンプト
      starship

      # 基本
      curl
      htop
      tree
    ];

    # stow の代わりに home.file でシンボリックリンク管理
    # mkOutOfStoreSymlink: nix store 外のファイルへのリンク (編集可能)
    file = {
      ".config/sheldon".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/sheldon";
      ".config/starship.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/starship.toml";
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
      ".config/wezterm".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/wezterm";
      ".config/mise/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/mise/config.toml";
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
      enableCompletion = false;

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        # ファイル操作
        ls  = "eza --icons";
        ll  = "eza -l --icons --git";
        la  = "eza -a --icons";
        lla = "eza -al --icons --git";
        rm  = "rm -i";
        cp  = "cp -i";
        mv  = "mv -i";

        # 検索
        grep = "grep --color=auto";

        # ディレクトリ移動
        ".."  = "cd ..";
        "..." = "cd ../..";

        # エディタ
        vi  = "nvim";
        vim = "nvim";

        # git
        g = "git";

        # ナビゲーション
        cdg  = "cd $(ghq list -p | fzf)";
        cdd  = "cd ~/dotfiles";
        vimc = "nvim ~/dotfiles/config/";

        # AI
        ca  = "cursor-agent";
      };

      # .zshrc 相当
      initContent = ''
        # compinit: 24時間キャッシュで compaudit をスキップ (起動時間の92%削減)
        autoload -U compinit
        if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
          compinit
        else
          compinit -C
        fi

        bindkey -e

        # mise shims モード: .zprofile はログインシェルでしか読まれないため
        # .zshrc (initContent) で PATH に追加する。
        # activate zsh (デフォルト) は毎プロンプトで _mise_hook を実行するため重く、
        # zprof 計測で起動時間の約55%を占めていた。shims モードはフックなしで軽量。
        export PATH="$HOME/.local/share/mise/shims:$PATH"

        # WezTerm shell integration
        source "$HOME/.config/wezterm/wezterm.sh"

        # safe-chain: npm/pip/uv 等のマルウェア検知ラッパー (mise で管理)
        [[ -f "$HOME/.safe-chain/scripts/init-posix.sh" ]] && source "$HOME/.safe-chain/scripts/init-posix.sh"

        # sheldon でプラグイン読み込み
        eval "$(sheldon source)"

        # claude abbreviations (zsh-abbr)
        abbr cl="claude"
        abbr clc="claude --continue"
        abbr cld="claude --dangerously-skip-permissions"
        abbr clcd="claude --continue --dangerously-skip-permissions"

        # terraform abbreviations (zsh-abbr)
        abbr te="terraform"
        abbr tei="terraform init"
        abbr tep="terraform plan"
        abbr tea="terraform apply"
        abbr tes="terraform state"
        abbr tesl="terraform state list"
        abbr tev="terraform validate"
        abbr tefmt="terraform fmt -recursive"

        # starship プロンプト
        eval "$(starship init zsh)"

        # Haskell (ghcup)
        [ -d "$HOME/.ghcup/bin" ] && export PATH="$HOME/.ghcup/bin:$PATH"

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
