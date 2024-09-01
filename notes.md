    #
    #   outputs = {
    #     # inherit self nixpkgs home-manager hyprland;
    #
    #     homeManagerModules = import ./modules/home-manager;
    #
    #     # homeConfigurations = {
    #     #   luis = home-manager.lib.homeManagerConfiguration {
    #     #     extraSpecialArgs = { inherit inputs outputs; };
    #     #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     #     modules = [
    #     #       ./home.nix
    #     #     ];
    #     #   };
    #     # };
    #
    #
    #   };
    # in
    # outputs // {
    #
    #   nixosConfigurations = {
    #     plo = nixpkgs.lib.nixosSystem {
    #       inherit system;
    #       specialArgs = { inherit inputs outputs; };
    #       modules = [
    #         /etc/nixos/configuration.nix
    #         ./configuration.nix
    #         home-manager.nixosModules.home-manager
    #       ];
    #     };
    #   };
    #
    # });
