{ pkgs, ... }:
{
  imports = [
    ./blackmatter.nix
    ./packages.nix
    ./secrets
    ./shadeflakes
    ./kubernetes
  ];
  home.stateVersion = "24.05";
  home.username = "luis";
  home.homeDirectory = "/home/luis";
}
