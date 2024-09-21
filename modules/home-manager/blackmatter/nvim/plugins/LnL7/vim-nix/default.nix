{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.LnL7.vim-nix;
in
{
  options.blackmatter.programs.nvim.plugins.LnL7.vim-nix.enable =
    mkEnableOption "LnL7/vim-nix";

  config = mkMerge [
    (mkIf cfg.enable {
      # nix syntax highlighting
      home.file.".local/share/nvim/site/pack/LnL7/start/vim-nix".source =
        builtins.fetchGit {
          url = "https://github.com/LnL7/vim-nix";
          ref = "master";
          rev = "e25cd0f2e5922f1f4d3cd969f92e35a9a327ffb0";
        };
    })
  ];
}
