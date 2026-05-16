{ ... }:

{
  home.homeDirectory = "/home/re2";

  programs.zsh.shellAliases = {
    hms = "home-manager switch --flake ~/dotfiles#wsl";
    hmd = "home-manager switch --flake ~/dotfiles#wsl --dry-run";
    open = "explorer.exe";
  };
}
