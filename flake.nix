{
  description = "blackmatter systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      requirements = {
        inherit inputs;
      };

      homeConfigurations = {
        luis = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./home.nix
          ];
        };
      };

      nixosModules = { };

      nixosConfigurations = {
        plo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit requirements; };
          modules = [
            /etc/nixos/configuration.nix
            ./nodes/plo
            home-manager.nixosModules.home-manager
          ];
        };
      };
    in

    # what flake is returning as outputs
    {
      inherit
        nixosConfigurations
        homeConfigurations;
      # nixosModules 
      # homeManagerModules;
    };
}
