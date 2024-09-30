{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
  url = "${common.baseRepoUrl}/${author}/${name}";
  common = import ../../../common;
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  rev = import ./rev.nix;
  ref = "master";
  author = "nvim-telescope";
  name = "telescope.nvim";
  plugName = "telescope";
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable =
    mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url; };
      home.file."${configPath}".source = ./config.lua;
    })
  ];
}
