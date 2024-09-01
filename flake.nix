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

    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ] (system:
    let
      outputs = {
        inherit self nixpkgs home-manager hyprland;

        homeManagerModules = import ./modules/home-manager;

        homeConfigurations = {
          luis = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs outputs; };
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home.nix
            ];
          };
        };

        nixosConfigurations = {
          plo = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
            inherit system;
            modules = [
              /etc/nixos/configuration.nix
              ./configuration.nix
              home-manager.nixosModules.home-manager
            ];
          };
        };

      };
    in
    outputs);
}
