{ ... }:

{
  home.homeDirectory = "/Users/re2";

  programs.zsh.shellAliases = {
    hms = "sudo darwin-rebuild switch --flake ~/dotfiles#mac";
    hmd = "darwin-rebuild check --flake ~/dotfiles#mac";
  };
}
