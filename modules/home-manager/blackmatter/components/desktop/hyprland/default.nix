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

			programs.obs-studio.enable = true;
      home.packages = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal
        hyprpicker
        hyprland
        dunst
        mako
				grim
				slurp
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
        nordzy-icon-theme
        nordzy-cursor-theme
      ];

      home.file.".local/share/icons/Nordzy-cursors" = {
        source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
      };

      home.file.".icons/Nordzy-cursors" = {
        source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
      };

      home.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        HYPRCURSOR_THEME = "Nordzy-cursors";
        HYPRCURSOR_SIZE = "24";
        XCURSOR_THEME = "Nordzy-cursors";
        XCURSOR_SIZE = "24";
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

			#xdph
      home.file.".config/hypr/xdph.conf".source = ./xdph.conf;

      # notifications
      services.dunst = {
        enable = true;
        package = pkgs.dunst;
        settings = {
          global = {
            font = "Sans 12";
            geometry = "top-right";
            transparency = 10;
            frame_width = 2;
            frame_color = "#4C566A";
            separator_height = 2;
            timeout = 3;
          };

          urgency_low = {
            background = "#2E3440";
            foreground = "#D8DEE9";
            frame_color = "#4C566A";
          };
          urgency_normal = {
            background = "#3B4252";
            foreground = "#ECEFF4";
            frame_color = "#5E81AC";
          };
          urgency_critical = {
            background = "#BF616A";
            foreground = "#ECEFF4";
            frame_color = "#BF616A";
          };
        };
      };
    })
  ];
}
