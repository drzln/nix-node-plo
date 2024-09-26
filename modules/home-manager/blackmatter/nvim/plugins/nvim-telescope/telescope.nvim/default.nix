{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.nvim-telescope."telescope.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.nvim-telescope."telescope.nvim".enable =
    mkEnableOption "nvim-telescope/telescope.nvim";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/nvim-telescope/start/telescope.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/nvim-telescope/telescope.nvim";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
