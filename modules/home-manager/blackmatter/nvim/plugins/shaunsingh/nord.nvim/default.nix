{ lib, config, ... }:
with lib;
let
	author = "shaunsingh";
	name = "nord.nvim";
	plugName = "nord";
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
  common = import ../../../common;
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  ref = "master";
  rev = import ./rev.nix;
  url = "https://github.com/shaunsingh/nord.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable = mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url;};
      home.file."${configPath}".source = ./config.lua;
    })
  ];
}
