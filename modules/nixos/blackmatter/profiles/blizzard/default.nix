{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.profiles.blizzard;
in
{
  # imports = [
  #   ../../components/nvim
  #   ../../components/shell
  #   ../../components/desktop
  #   ../../components/gitconfig
  #   ../../components/kubernetes
  # ];

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
        # blackmatter.components.nvim.enable = true;
        # blackmatter.components.shell.enable = true;
        blackmatter.components.desktop.enable = true;
        blackmatter.components.desktop.hyprland.enable = true;
        blackmatter.components.desktop.i3.enable = false;
      })
  ];
}
