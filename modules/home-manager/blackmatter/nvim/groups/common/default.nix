{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.common;
in
{
  options.blackmatter.programs.nvim.plugin.groups.common =
    {
      enable = mkEnableOption "common";
    };

  imports = [
    ../../groups/telescope
    ../../groups/treesitter
    ../../groups/keybindings
    ../../plugins/jcdickinson/http.nvim
    ../../plugins/nvim-lua/plenary
    ../../plugins/folke/which-key.nvim
    ../../plugins/folke/neodev.nvim
    ../../plugins/numToStr/Comment.nvim
    ../../plugins/ahmedkhalf/project.nvim
    ../../plugins/nvim-tree/nvim-web-devicons
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.programs.nvim.plugin.groups.telescope.enable = true;
          blackmatter.programs.nvim.plugin.groups.treesitter.enable = true;
          blackmatter.programs.nvim.plugin.groups.keybindings.enable = true;
          blackmatter.programs.nvim.plugins =
            {
              ahmedkhalf."project.nvim".enable = true;
              nvim-tree.nvim-web-devicons.enable = true;
              numToStr."Comment.nvim".enable = true;
              folke."neodev.nvim".enable = true;
              jcdickinson."http.nvim".enable = false;
              nvim-lua.plenary.enable = true;

              folke."which-key.nvim".enable = false;
            };
        }
      )
    ];
}
