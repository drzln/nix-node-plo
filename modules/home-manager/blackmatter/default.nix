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
      enable = mkEnableOption "enable blackmatter";
    };
  };
}
