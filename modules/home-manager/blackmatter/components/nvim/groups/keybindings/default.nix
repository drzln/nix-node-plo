{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.nvim.plugin.groups.keybindings;
  common = import ../../common;
  configPath = "${common.configHome}/keybindings/init.lua";
in
{
  options.blackmatter.components.nvim.plugin.groups.keybindings =
    {
      enable = mkEnableOption "keybindings";
    };

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          home.file."${configPath}".source = ./config.lua;
        }
      )
    ];
}
