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

  # imports = [
  #   ../../plugins/jcdickinson/http.nvim
  #   ../../plugins/nvim-lua/plenary
  #   ../../plugins/folke/which-key.nvim
  #   ../../plugins/folke/neodev.nvim
  #   ../../plugins/maaslalani/nordbuddy
  #   ../../plugins/numToStr/Comment
  #   ../../plugins/nathom/filetype
  # ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
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
