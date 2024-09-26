{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.hrsh7th.nvim-cmp;
in
{
  options.blackmatter.programs.nvim.plugins.hrsh7th.nvim-cmp.enable = mkEnableOption "hrsh7th/nvim-cmp";

  config = mkMerge [
    (mkIf cfg.enable {
      # plugin for completion hooks
      home.file.".local/share/nvim/site/pack/hrsh7th/start/nvim-cmp".source =
        builtins.fetchGit {
          url = "https://github.com/hrsh7th/nvim-cmp";
          ref = "main";
          rev = import ./rev.nix;
        };
    })
  ];
}
