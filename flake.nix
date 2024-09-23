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
    let
      inherit (self) outputs;
      overlays = import ./overlays/default.nix;
      darwin-pkgs = import nixpkgs { system = "x86_64-darwin"; };
      linux-pkgs = import nixpkgs { system = "x86_64-linux"; };
      deps = linux-pkgs.callPackage ./packages/neovim/deps { };
      neovim_drzln = linux-pkgs.callPackage ./packages/neovim { inherit deps; };
    in
    {
      packages = flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          neovim_drzln = pkgs.callPackage ./packages/neovim { inherit deps; };
        }
      );

      homeConfigurations = {
        "luis@plo" = home-manager.lib.homeManagerConfiguration {
          pkgs = linux-pkgs;
          inherit deps;
          modules = [
            ./users/luis/plo
          ];
        };

        "gab@plo" = home-manager.lib.homeManagerConfiguration {
          pkgs = linux-pkgs;
          inherit deps;
          modules = [
            ./users/gab/plo
          ];
        };
      };

      nixosConfigurations = {
        plo = linux-pkgs.lib.nixosSystem {
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
          system = "x86_64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./nodes/cid
          ];
          specialArgs = {
            pkgs = darwin-pkgs;
          };
        };
      };
    };
}

