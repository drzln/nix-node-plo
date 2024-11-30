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
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable) { })
  ];
}
