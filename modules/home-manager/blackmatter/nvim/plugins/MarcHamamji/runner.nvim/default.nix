{ lib, config, ... }:
with lib;
let
  author = "MarcHamamji";
  name = "runner.nvim";
  url = "https://github.com/${author}/${name}";
  ref = "main";
  rev = "9ae6f56b73471174c6c4d47581007c6781fb6b6e";
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
