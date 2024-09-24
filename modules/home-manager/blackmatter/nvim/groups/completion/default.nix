{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.completion;
in
{
  options.blackmatter.programs.nvim.plugin.groups.completion =
    {
      enable = mkEnableOption "completion";
    };

  imports = [
    ../../plugins/hrsh7th/nvim-cmp
    ../../plugins/hrsh7th/cmp-nvim-lsp
    ../../plugins/hrsh7th/cmp-cmdline
    ../../plugins/hrsh7th/cmp-buffer
    ../../plugins/hrsh7th/cmp-path
    ../../plugins/sar/cmp-lsp.nvim
    ../../plugins/ray-x/cmp-treesitter
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.programs.nvim.plugins =
            {
              hrsh7th.nvim-cmp.enable = true;
              ray-x.cmp-treesitter.enable = true;
              hrsh7th.cmp-nvim-lsp.enable = true;
              hrsh7th.cmp-cmdline.enable = true;
              sar."cmp-lsp.nvim".enable = true;
              hrsh7th.cmp-buffer.enable = true;
              hrsh7th.cmp-path.enable = true;

            };
        }
      )
    ];
}
