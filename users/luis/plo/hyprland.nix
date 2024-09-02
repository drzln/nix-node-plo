{ requirements, pkgs, ... }: {
  home.packages = with pkgs; [
    wofi
    dunst
    waybar
    swaybg
    kitty
    alacritty
  ];

  # Enable and configure Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      bind = [
        "Super+Shift+Q, exec, hyprctl dispatch exit"
        "Super+T, exec, alacritty"
        "Super+N, exec, notify-send \"Hyprland is working!\""
      ];
    };
    plugins =  [
      requirements.inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      # requirements.inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
      # requirements.inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      # requirements.inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
      # requirements.inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.borders-plus-plus
    ];
  };

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
