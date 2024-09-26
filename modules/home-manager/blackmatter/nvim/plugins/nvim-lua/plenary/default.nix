{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.nvim-lua.plenary;
in
{
  options.blackmatter.programs.nvim.plugins.nvim-lua.plenary.enable = mkEnableOption "nvim-lua/plenary";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/nvim-lua/start/plenary.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/nvim-lua/plenary.nvim";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
