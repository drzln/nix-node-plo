{ config, pkgs, requirements, ... }:

{
  imports = [
    ./programs.nix
    ./packages.nix
    ./background.nix
    requirements.outputs.homeManagerModules.blackmatter
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "luis";
  home.homeDirectory = "/home/luis";
  home.stateVersion = "24.05";

  blackmatter.programs.nvim.enable = true;
  blackmatter.shell.enable = true;
  blackmatter.gitconfig.enable = false;
  blackmatter.desktop.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod+SHIFT+Q, exec, hyprctl dispatch exit"
      ];
    };
  };
}
