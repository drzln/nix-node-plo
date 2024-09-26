{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.tpope.vim-rhubarb;
in
{
  options.blackmatter.programs.nvim.plugins.tpope.vim-rhubarb.enable = mkEnableOption "tpope/vim-rhubarb";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/tpope/start/vim-rhubarb".source =
        builtins.fetchGit {
          url = "https://github.com/tpope/vim-rhubarb";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
