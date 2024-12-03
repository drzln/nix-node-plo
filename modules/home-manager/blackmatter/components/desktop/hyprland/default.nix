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
    (mkIf cfg.enable { })
  ];
}
