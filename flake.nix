{
  description = "Flake for Neovim with custom configurations for Linux and macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin?branch=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
    };
  };

  outputs = { self, flake-utils, nixpkgs, home-manager, nix-darwin, hyprland, stylix, ... }@inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        inherit (self) outputs;

        overlays = import ./overlays/default.nix;

        pkgs = import nixpkgs {
          inherit system overlays;
        };

        deps = pkgs.callPackage ./packages/neovim/deps { };

        neovim_drzln = pkgs.callPackage ./packages/neovim { inherit deps; };
      in
      {
        packages = {
          neovim_drzln = neovim_drzln;
        };

        homeConfigurations = {
          "luis@plo" = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs;
            inherit deps;
            modules = [
              ./users/luis/plo
            ];
          };

          "gab@plo" = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs;
            inherit deps;
            modules = [
              ./users/gab/plo
            ];
          };
        };

        nixosConfigurations = {
          plo = pkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              /etc/nixos/configuration.nix
              ./nodes/plo
              home-manager.nixosModules.home-manager
            ];
          };
        };

        darwinConfigurations = {
          cid = nix-darwin.lib.darwinSystem {
            specialArgs = { inherit outputs; };
            system = "x86_64-darwin";
            modules = [
              home-manager.darwinModules.home-manager
              ./nodes/cid
            ];
          };
        };
      }
    );
}

