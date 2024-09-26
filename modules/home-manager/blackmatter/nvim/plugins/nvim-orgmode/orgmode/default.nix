{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.nvim-orgmode.orgmode;
in
{
  options.blackmatter.programs.nvim.plugins.nvim-orgmode.orgmode.enable =
    mkEnableOption "nvim-orgmode/orgmode";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/nvim-orgmode/start/orgmode".source =
        builtins.fetchGit {
          url = "https://github.com/nvim-orgmode/orgmode";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
