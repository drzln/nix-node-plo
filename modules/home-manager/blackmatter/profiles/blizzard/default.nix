{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.profiles.blizzard;
in
{
  imports = [
    ../../components/nvim
    ../../components/shell
    ../../components/desktop
    ../../components/gitconfig
    ../../components/kubernetes
  ];

  options = {
    blackmatter = {
      profiles = {
        blizzard = {
          enable = mkEnableOption "enable the blizzard profile";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable)
      {
        blackmatter.components.nvim.enable = true;
        blackmatter.components.nvim.package = pkgs.neovim_drzln;
        blackmatter.components.shell.enable = true;
        blackmatter.components.desktop.enable = true;
        blackmatter.components.desktop.hyprland.enable = true;
        blackmatter.components.desktop.i3.enable = false;
        blackmatter.components.kubernetes.enable = false;
        blackmatter.components.kubernetes.k3d.enable = false;
        blackmatter.components.kubernetes.k3d.client.enable = false;
      })
  ];
}
