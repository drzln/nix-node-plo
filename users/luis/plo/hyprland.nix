{ requirements, pkgs, ... }: {
  home.packages = with pkgs; [
    wofi
    dunst
    waybar
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod+SHIFT+Q, exec, hyprctl dispatch exit"
      ];
    };
  };
}
