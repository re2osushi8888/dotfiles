{ lib, username, ... }:

{
  home.homeDirectory = "/Users/${username}";

  home.activation.setDefaultApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v duti &>/dev/null; then
      duti -s dev.zed.Zed public.plain-text all
      duti -s dev.zed.Zed public.source-code all
    fi
  '';

  programs.zsh.shellAliases = {
    hms = "sudo darwin-rebuild switch --flake ~/dotfiles#mac";
    hmd = "darwin-rebuild check --flake ~/dotfiles#mac";
  };
}
