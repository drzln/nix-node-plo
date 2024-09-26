{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.nvim-lua."popup.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.nvim-lua."popup.nvim".enable =
    mkEnableOption "nvim-lua/popup.nvim";

  config = mkMerge [
    (mkIf cfg.enable {
      # nix syntax highlighting
      home.file.".local/share/nvim/site/pack/nvim-lua/start/popup.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/nvim-lua/popup.nvim";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
