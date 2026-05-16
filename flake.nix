{
  description = "re2osushi8888's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = system: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./nix/home/common.nix ] ++ extraModules;
        };
    in {
      homeConfigurations = {
        "mac" = mkHome "aarch64-darwin" [ ./nix/home/mac.nix ];
        "wsl" = mkHome "x86_64-linux" [ ./nix/home/wsl.nix ];
      };
    };
}
