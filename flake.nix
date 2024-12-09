{
  description = "Flake for Neovim with custom configurations for Linux and macOS";

  inputs = {
    nixhashsync = {
      url = "github:gahbdias/NixHashSync";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager?branch=master";
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

    hyprland-plugins = {
      url = "github;hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    stylix = {
      url = "github:danth/stylix";
    };
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    , home-manager
    , nix-darwin
    , hyprland
    , hyprland-plugins
    , stylix
    , sops-nix
    , nixhashsync
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      overlays = import ./overlays/default.nix
        ++ builtins.attrValues sops-nix.overlays ++ [
        (final: prev: {
          nixhashsync = nixhashsync.packages.${prev.system}.default;
        })
      ];
      requirements = { inherit inputs outputs; };
      specialArgs = { inherit requirements; };
      extraSpecialArgs = specialArgs;

      shared-pkg-attributes = {
        inherit overlays;
        config.allowUnfree = true;
      };

      darwin-pkgs = import nixpkgs
        {
          system = "x86_64-darwin";
          overlays = shared-pkg-attributes.overlays;
        } // shared-pkg-attributes;

      linux-pkgs = import nixpkgs
        {
          system = "x86_64-linux";
          overlays = shared-pkg-attributes.overlays;
        } // shared-pkg-attributes;

    in
    {
      packages = flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = shared-pkg-attributes.overlays;
          };
        in
        {
          neovim_drzln = pkgs.callPackage ./packages/neovim { };
          nixhashsync = nixhashsync.packages.${system}.default;
        }
      );

      homeManagerModules = import ./modules/home-manager;
      nixosModules = import ./modules/nixos;

      homeConfigurations = {
        "luis@plo" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = linux-pkgs;
          modules = [
            sops-nix.homeManagerModules.sops
            ./users/luis/plo
          ];
        };

        "gab@plo" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = linux-pkgs;
          modules = [
            sops-nix.homeManagerModules.sops
            ./users/gab/plo
          ];
        };

        "gaby@plo" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = linux-pkgs;
          modules = [
            ./users/gaby/plo
          ];
        };

        "gabrielad@gcd" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = linux-pkgs;
          modules = [
            ./users/gabrielad/gcd
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
            sops-nix.nixosModules.sops
          ];
        };

        gcd = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            /etc/nixos/configuration.nix
            ./nodes/gcd
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
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

