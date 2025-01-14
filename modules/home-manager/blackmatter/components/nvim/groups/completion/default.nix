{ config, lib, pkgs, ... }:
with lib;
let
  name = "completion";
  plugName = name;
  cfg = config.blackmatter.components.nvim.plugin.groups.${name};
  common = import ../../common;
  configPath = "${common.baseConfigPath}/groups/${plugName}.lua";
in
{
  options.blackmatter.components.nvim.plugin.groups.completion =
    {
      enable = mkEnableOption name;
    };

  imports = [
    ../../plugins/hrsh7th/nvim-cmp
    ../../plugins/hrsh7th/cmp-nvim-lsp
    ../../plugins/hrsh7th/cmp-cmdline
    ../../plugins/hrsh7th/cmp-buffer
    ../../plugins/hrsh7th/cmp-path
    ../../plugins/sar/cmp-lsp.nvim
    ../../plugins/ray-x/cmp-treesitter
    ../../plugins/L3MON4D3/LuaSnip
    ../../plugins/zbirenbaum/copilot-cmp
    ../../plugins/zbirenbaum/copilot.lua
    ../../plugins/rafamadriz/friendly-snippets
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          home.file."${configPath}".source = ./config.lua;
          blackmatter.components.nvim.plugins =
            {
              hrsh7th.nvim-cmp.enable = true;
              hrsh7th.cmp-nvim-lsp.enable = true;
              hrsh7th.cmp-cmdline.enable = true;
              hrsh7th.cmp-buffer.enable = true;
              hrsh7th.cmp-path.enable = true;
              L3MON4D3.LuaSnip.enable = true;

              ray-x.cmp-treesitter.enable = true;
              sar."cmp-lsp.nvim".enable = true;
              zbirenbaum."copilot.lua".enable = true;
              zbirenbaum."copilot-cmp".enable = true;
              rafamadriz.friendly-snippets.enable = true;
            };
        }
      )
    ];
}
