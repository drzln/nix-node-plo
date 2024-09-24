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
      requirements = { inherit inputs outputs; };
      specialArgs = { inherit requirements; };
      extraSpecialArgs = specialArgs;

      darwin-pkgs = import nixpkgs {
        inherit overlays;
        system = "x86_64-darwin";
        config.allowUnfree = true;
      };

      linux-pkgs = import nixpkgs { system = "x86_64-linux"; };
      neovim_drzln = linux-pkgs.callPackage ./packages/neovim { };
    in
    {
      packages = flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          neovim_drzln = pkgs.callPackage ./packages/neovim { };
        }
      );

      homeConfigurations = {
        "luis@plo" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = linux-pkgs;
          modules = [
            ./users/luis/plo
          ];
        };

        "gab@plo" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = linux-pkgs;
          modules = [
            ./users/gab/plo
          ];
        };
      };

      nixosConfigurations = {
        plo = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
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
            inherit inputs;
            pkgs = darwin-pkgs;
          };
        };
      };
    };
}

