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
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
					blackmatter.programs.nvim.plugins =
					{
						shaunsingh."nord.nvim".enable = true;
					};
        }
      )
    ];
}
