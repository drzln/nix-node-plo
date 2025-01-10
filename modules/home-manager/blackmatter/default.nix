{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter;
in
{
  imports = [
    ./profiles
		./components/microservices
  ];

  options = {
    blackmatter = {
      enable = mkEnableOption "enable blackmatter";
    };
  };
}
