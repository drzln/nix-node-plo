{ lib, config, ... }:
with lib;
let
	author = "shaunsingh";
	name = "nord.nvim";
	plugName = "nord";
  cfg = config.blackmatter.programs.nvim.plugins.shaunsingh.nord;
  common = import ../../../common;
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  ref = "master";
  rev = import ./rev.nix;
  url = "https://github.com/shaunsingh/nord.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.shaunsingh."nord".enable = mkEnableOption "shaunsingh/nord";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/shaunsingh/start/nord.nvim".source =
        builtins.fetchGit { inherit ref rev url;};
      home.file."${configPath}".source = ./config.lua;
    })
  ];
}
