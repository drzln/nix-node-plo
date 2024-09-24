{ lib, config, outputs, ... }:
with lib;
let
  common = import ../../../common;
  url = "${common.baseRepoUrl}/${author}/${name}";
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  configPath = "${common.baseConfigPath}/${author}/${name}.lua";
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
  author = "nvim-treesitter";
  name = "nvim-treesitter";
  ref = "master";
  rev = "fd9663acca289598086b7c5a366be8b2fa5d7960";
in
{
  options = {
    blackmatter = {
      programs = {
        nvim = {
          plugins = {
            nvim-treesitter = {
              nvim-treesitter = {
                enable = mkEnableOption "${author}/${name}";
              };
            };
          };
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url; };

      home.file."${configPath}".source = ./config.lua;
    })
  ];
}
