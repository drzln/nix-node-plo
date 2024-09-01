{
  description = "blackmatter systems";

  inputs = {
    ############################################################################
    # base modules
    ############################################################################

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # end base modules

    ############################################################################
    # utilities
    ############################################################################

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # end utilities

    ############################################################################
    # desktop modules
    ############################################################################

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    # end desktop modules
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , flake-utils
    , hyprland
    , ...
    }@inputs:
    let
      # build out outputs with inherit only
      outputs = rec {
        inherit 
        nixosConfigurations 
        homeConfigurations 
        homeManagerModules;
      };

      homeManagerModules = import ./modules/home-manager;

      homeConfigurations = {
        luis = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs; };
          pkgs = systems.x86_64-linux.pkgs;
          modules = [
            ./home.nix
          ];
        };
      };

      nixosConfigurations = {
        plo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            /etc/nixos/configuration.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };

      ##########################################################################
      # nixpkgs for multiple systems
      ##########################################################################
      systems = flake-utils.lib.eachSystem flake-utils.defaultSystems (system:
      let
        localPackages = {};
        pkgs = import nixpkgs { inherit system; } // localPackages;
      in
      {
        system = system;
        pkgs = pkgs;
      }); 
      # end nixpkgs for multiple systems

    in outputs;
}
