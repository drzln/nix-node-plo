{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.nvim;
  # inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
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

          # plugins = mkOption {
          #   type = types.attrsOf types.bool;
          #   default = { };
          #   description = mdDoc "A set of toggles for individual plugins";
          # };

          # pluginGroups = mkOption {
          #   type = types.attrsOf types.bool;
          #   default = {
          #     common = true;
          #     languages = true;
          #     lsp = true;
          #     theming = true;
          #     completion = true;
          #     debugging = false;
          #   };
          #   description = mdDoc "A set of toggles for groups of plugins";
          # };
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

      # Pass plugins and groups to blackmatter configuration
      # blackmatter.components.nvim = {
      #   plugins = cfg.plugins;
      #   plugin.groups = cfg.pluginGroups;
      # };
    })
  ];
}
