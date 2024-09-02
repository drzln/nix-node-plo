{ requirements, pkgs, ... }: {
  home.packages = with pkgs; [
    wofi
    dunst
    waybar
    swaybg
    # nordic-theme # Add a Nord theme package
    alacritty # Terminal with Nord theme support
  ];

  # Enable and configure Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod+SHIFT+Q, exec, hyprctl dispatch exit"
      ];
      # Appearance settings for Hyprland
      decoration = {
        rounding = 10;
        blur = true;
        border_size = 2;
        border_color = "4C566A"; # Nord color
      };
      gaps = {
        inner = 10;
        outer = 15;
      };
      colortheme = {
        background = "2E3440";
        foreground = "D8DEE9";
        accent = "88C0D0"; # Nord colors
      };
    };
  };

  # Waybar configuration
  # waybar = {
  #   enable = true;
  #   package = pkgs.waybar;
  #   config = ./waybar-config.json;
  #   style = ./waybar-style.css; # Custom Nord-themed CSS
  # };

  # Wofi configuration
  home.file.".config/wofi/config" = {
    text = ''
      [colors]
      background = "#2E3440";
      foreground = "#D8DEE9";
      selection_background = "#4C566A";
      selection_foreground = "#D8DEE9";
    '';
  };

  # Dunst configuration
  home.file.".config/dunst/dunstrc" = {
    text = ''
      [global]
      background = "#2E3440";
      foreground = "#D8DEE9";
      frame_color = "#4C566A";
    '';
  };
}
