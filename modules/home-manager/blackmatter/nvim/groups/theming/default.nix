{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.theming;
in
{
  options.blackmatter.programs.nvim.plugin.groups.theming =
    {
      enable = mkEnableOption "theming";
    };

  imports = [
    ../../plugins/shaunsingh/nord.nvim
    ../../plugins/nvim-lualine/lualine.nvim
    ../../plugins/norcalli/nvim-colorizer.lua
    ../../plugins/akinsho/bufferline.nvim
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.programs.nvim.plugins =
            {
              shaunsingh."nord.nvim".enable = true;
              nvim-lualine."lualine.nvim".enable = true;
              norcalli."nvim-colorizer.lua".enable = true;
              akinsho."bufferline.nvim".enable = true;
            };
        }
      )
    ];
}
