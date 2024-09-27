{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
  common = import ../../../common;
  url = "${common.baseRepoUrl}/${author}/${name}";
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  author = "camspiers";
  name = "lens.vim";
  plugName = "lens";
  ref = "master";
  rev = import ./rev.nix;
in
{
  options.blackmatter.programs.nvim.plugins.camspiers.lens.enable = mkEnableOption "camspiers/lens";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url; };

    })
  ];
}
