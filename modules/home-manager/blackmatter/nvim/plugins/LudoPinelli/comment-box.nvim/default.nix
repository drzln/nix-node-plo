{ lib, config, ... }:
with lib;
let
  author = "LudoPinelli";
  name = "comment-box.nvim";
  url = "https://github.com/${author}/${name}";
  ref = "main";
  rev = "06bb771690bc9df0763d14769b779062d8f12bc5";
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
