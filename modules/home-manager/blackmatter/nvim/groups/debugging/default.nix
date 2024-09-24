{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.debugging;
in
{
  options.blackmatter.programs.nvim.plugin.groups.debugging =
    {
      enable = mkEnableOption "debugging";
    };

  imports = [
    ../../plugins/ravenxrz/DAPInstall.nvim
    ../../plugins/yriveiro/dap-go.nvim
    ../../plugins/nvim-telescope/telescope-dap.nvim
    ../../plugins/Pocco81/dap-buddy.nvim
    ../../plugins/mfussenegger/nvim-dap
    ../../plugins/jbyuki/one-small-step-for-vimkind
    ../../plugins/leoluz/nvim-dap-go
    ../../plugins/mfussenegger/nvim-dap-python
    ../../plugins/theHamsta/nvim-dap-virtual-text
    ../../plugins/suketa/nvim-dap-ruby
    ../../plugins/rcarriga/nvim-dap-ui
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.programs.nvim.plugins =
            {
              ravenxrz."DAPInstall.nvim".enable = true;
              yriveiro."dap-go.nvim".enable = true;
              nvim-telescope."telescope-dap.nvim".enable = true;
              Pocco81."dap-buddy.nvim".enable = false;
              mfussenegger.nvim-dap.enable = true;
              jbyuki.one-small-step-for-vimkind.enable = true;
              leoluz.nvim-dap-go.enable = true;
              mfussenegger.nvim-dap-python.enable = true;
              theHamsta.nvim-dap-virtual-text.enable = true;
              suketa.nvim-dap-ruby.enable = true;
              rcarriga.nvim-dap-ui.enable = true;

            };
        }
      )
    ];
}
