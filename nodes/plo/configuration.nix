{ config, pkgs, requirements, ... }:
let
  pkgs-unstable = requirements.inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  sudo-users-common =
    {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "podman"
        "libvirtd"
        "audio"
        "video"
      ];
      packages = with pkgs; [
        home-manager
      ];
    };
in
{
  system.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;

  imports = [
    requirements.outputs.nixosModules.blackmatter
  ];

  blackmatter.profiles.blizzard.enable = true;

  users.users.luis = {
    uid = 1001;
    description = "luis";
  } // sudo-users-common;

  users.users.gab = {
    uid = 1002;
    description = "gab";
  } // sudo-users-common;

  users.users.gaby = {
    uid = 1003;
    description = "gaby";
  } // sudo-users-common;

  security.sudo.extraConfig = ''
    luis ALL=(ALL) NOPASSWD:ALL
    gab ALL=(ALL) NOPASSWD:ALL
    gaby ALL=(ALL) NOPASSWD:ALL
  '';
}
