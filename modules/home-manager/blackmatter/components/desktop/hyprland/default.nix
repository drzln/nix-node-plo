{ lib, pkgs, config, ... }:
with lib;
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  cfg = config.blackmatter.components.desktop.hyprland;
in
{
  options = {
    blackmatter = {
      components = {
        desktop.hyprland.enable = mkEnableOption "hyprland";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {

      home.packages = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal
        hyprpicker
        hyprland
        dunst
        mako
        fnott
        wofi
        waybar
        kitty
        hyprpaper
        hypridle
        hyprlock
        hyprcursor
        hyprutils
        hyprlang
        hyprwayland-scanner
        aquamarine
      ];

      home.sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        QT_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      # hyprland
      home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
      home.file.".config/hypr/env.conf".source = ./env.conf;
      home.file.".config/hypr/input.conf".source = ./input.conf;
      home.file.".config/hypr/monitors.conf".source = ./monitors.conf;
      home.file.".config/hypr/variables.conf".source = ./variables.conf;
      home.file.".config/hypr/general.conf".source = ./general.conf;
      home.file.".config/hypr/autostart.conf".source = ./autostart.conf;
      home.file.".config/hypr/cursor.conf".source = ./cursor.conf;
      home.file.".config/hypr/workspaces.conf".source = ./workspaces.conf;

      #waybar
      home.file.".config/waybar/config".source = ./waybar-config.json;
      home.file.".config/waybar/style.css".source = ./waybar-style.css;

      # hyprpaper
      home.file.".config/hypr/wallpaper.jpg".source = ./wallpaper.jpg;
      home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;

      # hypridle
      home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;

      #hyprlock
      home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    })
  ];
}
