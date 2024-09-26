{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.mfussenegger.nvim-dap-python;
in
{
  options.blackmatter.programs.nvim.plugins.mfussenegger.nvim-dap-python.enable =
    mkEnableOption "mfussenegger/nvim-dap-python";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/mfussenegger/start/nvim-dap-python".source =
        builtins.fetchGit {
          url = "https://github.com/mfussenegger/nvim-dap-python";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
