{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.keybindings;
  common = import ../../common;
  configPath = "${common.baseConfigPath}/groups/keybindings.lua";
in
{
  options.blackmatter.programs.nvim.plugin.groups.keybindings =
    {
      enable = mkEnableOption "keybindings";
    };

  # imports = [
  #   ../../groups/telescope
  #   ../../groups/treesitter
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
					home.file."${configPath}".source = ./config.lua;
					# blackmatter.programs.nvim.plugin.groups.telescope.enable = true;
					# blackmatter.programs.nvim.plugin.groups.treesitter.enable = true;
          # blackmatter.programs.nvim.plugins =
          #   {
          #     numToStr.Comment.enable = true;
          #     folke."neodev.nvim".enable = true;
          #     jcdickinson."http.nvim".enable = false;
          #     nathom.filetype.enable = true;
          #     nvim-lua.plenary.enable = true;
          #
          #     folke."which-key.nvim".enable = false;
          #     maaslalani.nordbuddy.enable = false;
          #   };
        }
      )
    ];
}
