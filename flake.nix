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

  outputs = {nixpkgs, home-manager, ...}@inputs: {
    homeConfigurations = {
      luis = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs;};
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
        ];
      };
    };

    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      plo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs homeConfigurations; };
        modules = [
          /etc/nixos/configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };

    nixosModules = {};
  };

  # outputs = { self
  #   , nixpkgs
  #   , home-manager
  #   , hyprland
  #   , ...
  #   }@inputs:
  #   let
  #     inherit (self) outputs;
  #
  #     # arguments for nixos modules
  #     specialArgs = { inherit inputs outputs; };
  #
  #     # arguments for home-manager modules
  #     extraSpecialArgs = { inherit inputs outputs; };
  #   in
  #
  #   {
  #     homeManagerModules = import ./modules/home-manager;
  #
  #     homeConfigurations = {
  #       luis = home-manager.lib.homeManagerConfiguration {
  #         inherit extraSpecialArgs;
  #         pkgs = nixpkgs.legacyPackages.x86_64-linux;
  #         modules = [
  #           ./home.nix
  #         ];
  #       };
  #     };
  #
  #     nixosConfigurations = {
  #       plo = nixpkgs.lib.nixosSystem {
  #         system = "x86_64-linux";
  #         inherit specialArgs;
  #         modules = [
  #           /etc/nixos/configuration.nix
  #           ./configuration.nix
  #           home-manager.nixosModules.home-manager
  #         ];
  #       };
  #     };
  #   };
}
