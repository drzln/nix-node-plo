{ lib, config, pkgs, ... }:
let
  cfg = config.blackmatter.components.nvim.groups;
in
with lib;
{
  imports = [
    ./common
    ./lsp
    ./languages
    ./completion
    ./theming
    ./debugging
    ./tmux
  ];

  # options = {
  #   blackmatter = {
  #     components = {
  #       nvim = {
  #         groups = {
  #           enabled = { };
  #         };
  #       };
  #     };
  #   };
  # };
}
