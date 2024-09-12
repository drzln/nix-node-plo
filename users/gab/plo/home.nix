{ pkgs, ... }:
{
  imports = [
    ./programs.nix
    ./packages.nix
    ./background.nix
    ./hyprland.nix
    ./blackmatter.nix
  ];
  home.stateVersion = "24.05";
  home.username = "gab";
  home.homeDirectory = "/home/gab";
  nixpkgs.config.allowUnfree = true;
}
