{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.tmux;
in
{
  options.blackmatter.programs.nvim.plugin.groups.tmux =
    {
      enable = mkEnableOption "tmux";
    };

  imports = [
    ../../plugins/christoomey/vim-tmux-navigator
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.programs.nvim.plugins =
            {
              christoomey.vim-tmux-navigator.enable = true;
            };
        }
      )
    ];
}
