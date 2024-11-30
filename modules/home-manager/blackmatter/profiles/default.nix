{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.profiles;
in
{
  options = {
    blackmatter = {
      profiles = {
        winter = {
          enable = mkEnableOption "enable the winter profile";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.winter.enable)
      {
        import = [
          # ./winter
        ];
      })
  ];
}
