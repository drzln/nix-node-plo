{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter;
in
{
  imports = [
    ./profiles
  ];

  options = {
    blackmatter = {
      enable = mkEnableOption "enable blackmatter as a whole and the ability to select profiles";
      profile = mkOption {
        type = types.enum [ "winter" ];
        default = "winter";
        description = "Available profiles for desktop environments.";
      };
    };
  };

  config = mkMerge [
    # Ensure the profile exists in `blackmatter` before enabling it
    (mkIf (cfg.enable && cfg.profile != null) {
      blackmatter.${cfg.profile}.enable = true; # Dynamically enable the selected profile
    })
  ];
}
