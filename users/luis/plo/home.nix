{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./blackmatter.nix
    ./secrets
    ./shadeflakes
    ./kubernetes
  ];
  home.stateVersion = "24.05";
  home.username = "luis";
  home.homeDirectory = "/home/luis";
}
