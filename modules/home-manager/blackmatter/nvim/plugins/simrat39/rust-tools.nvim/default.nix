{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.simrat39."rust-tools.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.simrat39."rust-tools.nvim".enable =
    mkEnableOption "simrat39/rust-tools.nvim";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/simrat39/start/rust-tools.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/simrat39/rust-tools.nvim";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
