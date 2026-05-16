{ ... }: {
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPath = [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ];

  users.users.re2 = {
    name = "re2";
    home = "/Users/re2";
  };

  homebrew = {
    enable = true;
    casks = [
      "wezterm"
    ];
  };

  system.primaryUser = "re2";

  system.stateVersion = 5;
}
