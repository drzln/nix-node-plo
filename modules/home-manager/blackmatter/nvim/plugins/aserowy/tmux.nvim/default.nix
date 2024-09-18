{ lib, config, ... }:
with lib;
let
  author = "aserowy";
  name = "tmux.nvim";
  url = "https://github.com/${author}/${name}";
  ref = "main";
  rev = "65ee9d6e6308afcd7d602e1320f727c5be63a947";

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
