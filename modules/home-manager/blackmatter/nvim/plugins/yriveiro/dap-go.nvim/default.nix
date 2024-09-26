{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.yriveiro."dap-go.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.yriveiro."dap-go.nvim".enable =
    mkEnableOption "yriveiro/dap-go.nvim";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/yriveiro/start/dap-go.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/yriveiro/dap-go.nvim";
          ref = "main";
          rev = import ./rev.nix;
        };
    })
  ];
}
