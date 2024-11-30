{ lib, pkgs, config, profile, ... }:
with lib;
let
  cfg = config.blackmatter;
in
{
  # Import additional modules
  imports = [
		./profiles
    # ./alacritty
    # ./packages
    # ./firefox
    # ./i3
    # ./kitty
    # ./chrome
  ];

  options = {
    blackmatter = {
      desktop = {
        enable = mkEnableOption "Enable the desktop environment configuration based on the selected profile.";
        profiles = mkOption {
          type = types.enum [ "winter" ];
          default = "winter";
          description = "Available profiles for desktop environments.";
        };
      };
    };
  };

  config = mkMerge [
    # Ensure the profile exists in `blackmatter` before enabling it
    (mkIf (cfg.desktop.enable && cfg.desktop.profile != null) {
      blackmatter.${cfg.desktop.profile}.enable = true; # Dynamically enable the selected profile
    })
  ];
}
