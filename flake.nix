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

  outputs =
    { self
    , nixpkgs
    , home-manager
    , hyprland
    , ...
    }@inputs:
    let
      systems =

        let
          inherit (self) outputs;
        in

          {
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
                system = "x86_64-linux";
                specialArgs = { inherit inputs outputs; };
                modules = [
                  /etc/nixos/configuration.nix
                  ./configuration.nix
                  home-manager.nixosModules.home-manager
                ];
              };
            };
          };

    in systems;
}
