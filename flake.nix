{
  description = "blackmatter systems";

  inputs = {
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    hyprland, 
    ... }@inputs: {
    inherit outputs;

    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

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
        system = "x86_64-linux";
        modules = [
          /etc/nixos/configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
