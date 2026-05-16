{ ... }:

{
  home.homeDirectory = "/Users/re2";

  programs.zsh.shellAliases = {
    hms = "home-manager switch --flake ~/dotfiles#mac";
    hmd = "home-manager switch --flake ~/dotfiles#mac --dry-run";
  };
}
