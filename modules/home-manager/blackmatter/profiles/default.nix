{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.profile;
in
{
  options = {
    blackmatter = {
      winter = {
        enable = mkEnableOption "enable the winter profile";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.winter.enable)
      {
        import = [
          ./winter
        ];
      })
  ];
}
