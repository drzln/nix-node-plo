{ pkgs, ... }:
{
  imports = [
    ./blackmatter.nix
    ./packages.nix
    ./secrets
    ./shadeflakes
  ];
  home.stateVersion = "24.05";
  home.username = "luis";
  home.homeDirectory = "/home/luis";
}
