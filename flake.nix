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

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;

      requirements = {
        inherit inputs outputs;
      };

      specialArgs = { inherit requirements; };
      extraSpecialArgs = specialArgs;

      homeManagerModules = import ./modules/home-manager;

      homeConfigurations = {
        "luis@plo" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./users/luis/plo
          ];
        };
      };

      nixosModules = import ./modules/nixos;

      nixosConfigurations = {
        plo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            /etc/nixos/configuration.nix
            ./nodes/plo
            home-manager.nixosModules.home-manager
          ];
        };
      };
    in

    {
      inherit
        nixosConfigurations
        nixosModules
        homeConfigurations
        homeManagerModules;
    };
}
