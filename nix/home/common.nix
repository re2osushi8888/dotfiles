{ config, pkgs, username, ... }:

{
  home = {
    username = username;
    stateVersion = "25.05";

    sessionPath = [
      "$HOME/bin"
    ];

    packages = with pkgs; [
      # シェルツール
      sheldon
      mise

      # 検索・ナビゲーション
      ripgrep
      fd
      ghq
      bat

      # ターミナル
      zellij
      glow

      # 開発ツール
      lazygit
      delta
      stylua
      tree-sitter
      neovim
      lua-language-server
      typescript-language-server
      prisma-language-server

      # CLI
      gh
      jq
      claude-code
      cursor-cli

      # シェルプロンプト
      starship

      # 基本
      curl
      htop
    ];

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
        ghq.root = [ "~/work" "~/repos" ];
        "ghq \"https://github.com/re2osushi8888\"".root = "~/repos/";
        "includeIf \"gitdir:~/work/\"".path = "~/work/.gitconfig";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = false;

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        # ファイル操作
        ll  = "ls -l";
        la  = "ls -a";
        lla = "ls -al";
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
        cl  = "claude";
        clc = "claude --continue";
        ca  = "cursor-agent";
      };

      initContent = ''
        autoload -U compinit
        if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
          compinit
        else
          compinit -C
        fi

        bindkey -e

        export PATH="$HOME/.local/share/mise/shims:$PATH"

        source "$HOME/.config/wezterm/wezterm.sh"

        [[ -f "$HOME/.safe-chain/scripts/init-posix.sh" ]] && source "$HOME/.safe-chain/scripts/init-posix.sh"

        eval "$(sheldon source)"

        eval "$(starship init zsh)"

        [ -d "$HOME/.ghcup/bin" ] && export PATH="$HOME/.ghcup/bin:$PATH"

        if command -v git >/dev/null 2>&1; then
          for alias in $(git config --get-regexp '^alias\.' | sed 's/^alias\.\([^ ]*\) .*/\1/'); do
            alias g''${alias}="git ''${alias}"
          done
        fi
      '';
    };
  };
}
