{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter;
in
{

  options = {
    blackmatter = {
      enable = mkEnableOption "enable blackmatter as a whole and the ability to select profiles";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.profile != null) {
      imports = [
        ./profiles
      ];
    })
  ];
}
