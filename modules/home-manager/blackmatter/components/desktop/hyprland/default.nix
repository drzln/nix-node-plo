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
        # desktop.hyprland.monitors = mkOption {
        #   type = types.attrs;
        #   description = "monitor related attributes";
        # };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # programs.regreet.enable = true;
      # Install Hyprland and related packages
      home.packages = with pkgs; [
        hyprland
        dunst
        mako
        fnott
        wofi
        waybar # Status bar for Wayland
        swaybg # Background image handler
        kitty # Terminal emulator
				hyprpaper
				hyprpicker
				hypridle
				hyprlock
				xdg-desktop-portal-hyprland
				hyprcursor
				hyprutils
				hyprlang
				hyprwayland-scanner
				aquamarine
				# hyprgraphics
				# hyprland-qtutils
				# hyprwall
				# hyprsunset
				# hyprpolkitagent
				# hyprsysteminfo
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

      # Manage the configuration
      home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
      home.file.".config/hypr/env.conf".source = ./env.conf;
      home.file.".config/hypr/input.conf".source = ./input.conf;
      home.file.".config/hypr/monitors.conf".source = ./monitors.conf;
      home.file.".config/hypr/variables.conf".source = ./variables.conf;
      home.file.".config/hypr/general.conf".source = ./general.conf;
      home.file.".config/hypr/autostart.conf".source = ./autostart.conf;
      home.file.".config/hypr/cursor.conf".source = ./cursor.conf;
      home.file.".config/hypr/workspaces.conf".source = ./workspaces.conf;
      home.file.".config/hypr/wallpaper.jpg".source = ./wallpaper.jpg;
      home.file.".config/waybar/config".source = ./waybar-config.json;
      home.file.".config/waybar/style.css".source = ./waybar-style.css;
    })
  ];
}
