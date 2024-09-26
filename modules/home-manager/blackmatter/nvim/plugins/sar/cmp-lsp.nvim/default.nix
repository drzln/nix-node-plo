{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.sar."cmp-lsp.nvim";
in
{
  options.blackmatter.programs.nvim.plugins.sar."cmp-lsp.nvim".enable =
    mkEnableOption "sar/cmp-lsp.nvim";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.".local/share/nvim/site/pack/sar/start/cmp-lsp.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/sar/cmp-lsp.nvim";
          ref = "main";
          rev = import ./rev.nix;
        };
    })
  ];
}
