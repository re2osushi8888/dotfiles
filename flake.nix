{
  description = "re2osushi8888's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }:
    let
      macUser = "re2";
      wslUser = "re2";
    in {

    # macOS (nix-darwin + home-manager)
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { username = macUser; };
      modules = [
        ./nix/system/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { username = macUser; };
            users.${macUser}.imports = [
              ./nix/home/common.nix
              ./nix/home/mac.nix
            ];
          };
        }
      ];
    };

    # WSL Ubuntu (home-manager standalone)
    homeConfigurations."wsl" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      extraSpecialArgs = { username = wslUser; };
      modules = [
        ./nix/home/common.nix
        ./nix/home/wsl.nix
      ];
    };

  };
}
