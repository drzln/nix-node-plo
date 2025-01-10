{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.microservices;
in
{
  imports =
    [
      ./groups
    ];

  options = {
    blackmatter = {
      components = {
        nvim = {
          enable = mkEnableOption "Enable Neovim configuration";

          package = mkOption {
            type = types.package;
            default = pkgs.neovim;
            description = mdDoc "Neovim package/derivation";
          };
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # Include the Neovim package
      home.packages = [ cfg.package ];

      # Configure Neovim files
      xdg.configFile."nvim/init.lua".source = ./conf/init.lua;
      xdg.configFile."nvim/lua/plugins/init.lua".source = ./conf/lua/plugins/init.lua;
      xdg.configFile."nvim/lua/utils".source = ./conf/lua/utils;
      xdg.configFile."nvim/lua/lsp".source = ./conf/lua/lsp;
      xdg.configFile."nvim/after".source = ./conf/after;

      blackmatter.components.nvim.plugin.groups.enable = true;
    })
  ];
}
