{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.profiles.blizzard;
in
{
  imports = [
    ./boot
    ./limits
    ./docker
    ./time
    ./locale
    ./xserver
    ./displayManager
    ./virtualisation
    ./bluetooth
    ./sound
    ./networking
    ./nix
  ];

  options = {
    blackmatter = {
      profiles = {
        blizzard = {
          enable = mkEnableOption "enable the blizzard profile";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable)
      {
        powerManagement.cpuFreqGovernor = "performance";
        environment.variables = {
          GBM_BACKEND = "nvidia-drm";
        };
        services.dbus.enable = true;
        services.udev.enable = true;
        services.printing.enable = false;
        services.hardware.bolt.enable = false;
        services.nfs.server.enable = false;
        security.rtkit.enable = true;
        services.seatd.enable = true;
        services.xserver.videoDrivers = [ "nvidia" ];
        console = { font = "Lat2-Terminus16"; keyMap = "us"; };
        programs.zsh.enable = true;
        services.libinput = { enable = true; };
        xdg.portal.enable = true;
        xdg.portal.wlr.enable = true;
        hardware.graphics = {
          opengl.enable = true;
          nvidia = {
            open = false;
            modesettings.enable = true;
          };
          enable = true;
          package = pkgs-unstable.mesa.drivers;
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
        fonts.fontconfig.enable = true;
        fonts.fontDir.enable = true;
        fonts.enableDefaultPackages = true;
        fonts.packages = with pkgs; [
          fira-code
          fira-code-symbols
          dejavu_fonts
        ];
        programs.hyprland.enable = false;
        programs.hyprland.xwayland.enable = false;
        programs.hyprland.package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        programs.hyprland.portalPackage = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        services.greetd = {
          enable = true;
          greeter = {
            package = pkgs.agreety;
          };
          defaultSession = "hyprland";
          sessions = [
            {
              name = "hyprland";
              command = "${pkgs.hyprland}/bin/Hyprland";
            }
          ];
        };
      })
  ];
}
