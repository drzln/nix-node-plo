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
      inherit (self) outputs;

      requirements = {
        inherit inputs outputs;
      };

      homeManagerModules = import ./modules/home-manager;

      homeConfigurations = {
        luis = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit requirements; };
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./users/luis
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
        homeConfigurations
        homeManagerModules;
      # nixosModules 
      # homeManagerModules;
    };
}
