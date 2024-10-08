{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
  common = import ../../../common;
  url = "${common.baseRepoUrl}/${author}/${name}";
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  ref = "master";
  rev = import ./rev.nix;
  author = "lukas-reineke";
  name = "indent-blankline.nvim";
  plugName = "indent-blankline";
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable = mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit rev ref url; };
      home.file."${configPath}".source = ./config.lua;
    })
  ];
}
