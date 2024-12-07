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
      ];

      # Manage the configuration
      home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
      home.file.".config/hypr/wallpaper.jpg".source = ./wallpaper.jpg;
      # Optionally manage Waybar configuration
      home.file.".config/waybar/config".source = ./waybar-config.json;
      home.file.".config/waybar/style.css".source = ./waybar-style.css;
      # home.file.".config/tuigreet/config".text = ''
      #   # Example tuigreet config options
      #   # Set a custom greeting message
      #   greeting = "Welcome to Hyprland"
      #
      #   # Adjust colors (example values, not actual)
      #   fg_color = "#D8DEE9"
      #   bg_color = "#2E3440"
      # '';
      # Set environment variables for Wayland applications
      home.sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
				XDG_SESSION_DESKTOP =  "Hyprland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        QT_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
    })
  ];
}
