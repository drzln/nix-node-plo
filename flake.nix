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

      outputs = rec {
          inherit nixosConfigurations;
      };
    in 
      outputs;
}
