{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.nvim-lualine.lualine;
in
{
  options.blackmatter.programs.nvim.plugins.nvim-lualine.lualine.enable = mkEnableOption "nvim-lualine/lualine";

  config = mkMerge [
    (mkIf cfg.enable {
      # control neovim status bar at bottom
      home.file.".local/share/nvim/site/pack/nvim-lualine/start/lualine.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/nvim-lualine/lualine.nvim";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
