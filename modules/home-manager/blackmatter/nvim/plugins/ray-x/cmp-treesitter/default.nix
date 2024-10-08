{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.ray-x.cmp-treesitter;
in
{
  options.blackmatter.programs.nvim.plugins.ray-x.cmp-treesitter.enable =
    mkEnableOption "ray-x/cmp-treesitter";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/ray-x/start/cmp-treesitter".source =
        builtins.fetchGit {
          url = "https://github.com/ray-x/cmp-treesitter";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
