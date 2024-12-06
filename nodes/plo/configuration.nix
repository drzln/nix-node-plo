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

  imports = [
    requirements.outputs.nixosModules.blackmatter
  ];

  console = { font = "Lat2-Terminus16"; keyMap = "us"; };

  programs.zsh.enable = true;
  services.libinput = { enable = true; };

  blackmatter.profiles.blizzard.enable = true;

  hardware.nvidia.open = false;
  hardware.graphics = {
    enable = true;
    package = pkgs-unstable.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
    ];
  };

  hardware.nvidia.modesetting.enable = true;

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
  };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    vim
    wget
    git
    bash
    fontconfig
  ];

  programs.hyprland.enable = false;
  programs.hyprland.xwayland.enable = false;
  programs.hyprland.package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  programs.hyprland.portalPackage = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  services.dbus.enable = true;
  services.udev.enable = true;

  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    dejavu_fonts
  ];
}
