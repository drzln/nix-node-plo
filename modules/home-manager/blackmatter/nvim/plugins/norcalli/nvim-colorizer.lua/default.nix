{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.norcalli."nvim-colorizer.lua";
in
{
  options.blackmatter.programs.nvim.plugins.norcalli."nvim-colorizer.lua".enable =
    mkEnableOption "norcalli/nvim-colorizer.lua";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/norcalli/start/nvim-colorizer.lua".source =
        builtins.fetchGit {
          url = "https://github.com/norcalli/nvim-colorizer.lua";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
