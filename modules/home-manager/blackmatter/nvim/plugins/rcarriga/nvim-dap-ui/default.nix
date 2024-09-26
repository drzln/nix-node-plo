{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.rcarriga.nvim-dap-ui;
in
{
  options.blackmatter.programs.nvim.plugins.rcarriga.nvim-dap-ui.enable =
    mkEnableOption "rcarriga/nvim-dap-ui";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/rcarriga/start/nvim-dap-ui".source =
        builtins.fetchGit {
          url = "https://github.com/rcarriga/nvim-dap-ui";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
