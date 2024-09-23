{ lib, config, ... }:
with lib;
let
  author = "L3MON4D3";
  name = "LuaSnip";
  url = "https://github.com/${author}/${name}";
  ref = "master";
  rev = "e808bee352d1a6fcf902ca1a71cee76e60e24071";
  plugPath = ".local/share/nvim/site/pack/${author}/start/${name}";
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable =
    mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url; };
    })
  ];
}
