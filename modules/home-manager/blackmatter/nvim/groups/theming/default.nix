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
					shaunsingh."nord.nvim".enable = true;
          # blackmatter.programs.nvim.plugins =
          #   {
          #     numToStr.Comment.enable = true;
          #     jcdickinson."http.nvim".enable = false;
          #     maaslalani.nordbuddy.enable = true;
          #     nvim-lua.plenary.enable = true;
          #     folke."which-key.nvim".enable = true;
          #     folke."neodev.nvim".enable = true;
          #     nathom.filetype.enable = true;
          #   };
        }
      )
    ];
}
