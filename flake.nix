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

  outputs = {nixpkgs, home-manager, ...}@inputs: 
  let
    homeManagerModules = import ./modules/home-manager;

    homeConfigurations = {
      luis = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs;};
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
        ];
      };
    };

    nixosModules = {};
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
  in
  {
    inherit 
    nixosConfigurations 
    nixosModules 
    homeConfigurations 
    homeManagerModules;
  };
}
