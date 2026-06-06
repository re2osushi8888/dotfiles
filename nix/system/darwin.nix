{ username, ... }: {
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPath = [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  homebrew = {
    enable = true;
    casks = [
      "cursor"
      "discord"
      "ghostty"
      "google-chrome"
      "obsidian"
      "slack"
      "visual-studio-code"
      "wezterm"
    ];
  };

  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };

    dock = {
      show-recents = false;
      tilesize = 96;
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/System/Applications/System Settings.app"
        "/Applications/Google Chrome.app"
        "/Applications/WezTerm.app"
        "/Applications/Ghostty.app"
        "/Applications/Slack.app"
        "/Applications/Discord.app"
      ];
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  programs.zsh.enable = true;

  system.primaryUser = username;

  system.stateVersion = 5;
}
