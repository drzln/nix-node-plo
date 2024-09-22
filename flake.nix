{
  description = "flake holding drzln systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      packagesFor = system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        {
          neovim_drzln = pkgs.neovim_drzln;
        };


      systems = [ "x86_64-linux" "x86_64-darwin" ];
      packages = builtins.listToAttrs (map
        (s: {
          name = s;
          value = packagesFor s;
        })
        systems);

      inherit (self) outputs;

      requirements = {
        inherit inputs outputs;
      };

      overlays = import ./overlays;

      specialArgs = { inherit requirements; };
      extraSpecialArgs = specialArgs;

      homeManagerModules = import ./modules/home-manager;

      # homeConfigurations = {
      #
      #   "luis@plo" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = packages."x86_64-linux".pkgs;
      #     inherit extraSpecialArgs;
      #     modules = [
      #       ./users/luis/plo
      #     ];
      #   };
      #
      #   "gab@plo" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = packages."x86_64-linux".pkgs;
      #     inherit extraSpecialArgs;
      #     modules = [
      #       ./users/gab/plo
      #     ];
      #   };
      #
      # };

      # nixosModules = import ./modules/nixos;

      # nixosConfigurations = {
      #   plo = nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     inherit specialArgs;
      #     modules = [
      #       /etc/nixos/configuration.nix
      #       ./nodes/plo
      #       home-manager.nixosModules.home-manager
      #     ];
      #   };
      # };

      # darwinConfigurations = {
      #   cid = nix-darwin.lib.darwinSystem {
      #     specialArgs = { inherit outputs; };
      #     system = "x86_64-darwin";
      #     modules = [
      #       home-manager.darwinModules.home-manager
      #       ./nodes/cid
      #     ];
      #   };
      # };
    in

    {
      inherit
        packages;
      # darwinConfigurations
      # nixosConfigurations
      # nixosModules
      # homeConfigurations
      # homeManagerModules;
    };
}
