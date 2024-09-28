{ lib, config, ... }:
with lib;
let
  common = import ../../../common;
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
	author = "hrsh7th";
	name = "nvim-cmp";
	plugName = name;
  url = "${common.baseRepoUrl}/${author}/${name}";
  ref = "main";
  rev = import ./rev.nix;
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable = mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref ref url;};
      home.file."${configPath}".source = ./config.lua;
    })
  ];
}
