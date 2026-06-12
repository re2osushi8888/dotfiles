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
    taps = [ "manaflow-ai/cmux" ];
    casks = [
      "cmux"
      "cursor"
      "discord"
      "ghostty"
      "google-chrome"
      "obsidian"
      "slack"
      "visual-studio-code"
      "intellij-idea-ce"
      "raycast"
      "zed"
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
        "/System/Applications/Apps.app"
        "/System/Applications/System Settings.app"
        "/Applications/Google Chrome.app"
        "/Applications/WezTerm.app"
        "/Applications/Slack.app"
        "/Applications/Discord.app"
        "/Applications/WebPomodoro.app"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  programs.zsh.enable = true;

  system.primaryUser = username;

  system.stateVersion = 5;
}
