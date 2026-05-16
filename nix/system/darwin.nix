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

  programs.zsh.enable = true;

  system.primaryUser = username;

  system.stateVersion = 5;
}
