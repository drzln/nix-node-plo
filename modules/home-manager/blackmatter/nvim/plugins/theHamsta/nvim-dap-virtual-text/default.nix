{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.theHamsta."nvim-dap-virtual-text";
in
{
  options.blackmatter.programs.nvim.plugins.theHamsta."nvim-dap-virtual-text".enable =
    mkEnableOption "theHamsta/nvim-dap-virtual-text";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/theHamsta/start/nvim-dap-virtual-text".source =
        builtins.fetchGit {
          url = "https://github.com/theHamsta/nvim-dap-virtual-text";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
