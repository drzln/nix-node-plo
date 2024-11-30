{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.languages;
in
{
  options.blackmatter.programs.nvim.plugin.groups.languages =
    {
      enable = mkEnableOption "languages";
    };

  imports = [
    ../../plugins/hashivim/vim-terraform
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.programs.nvim.plugins =
            {
              hashivim."vim-terraform".enable = false;
            };
        }
      )
    ];
}
