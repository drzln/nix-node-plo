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
  rev = "621f5901f0b3e762cc4c5ed0f9246cf1495193ad";
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
