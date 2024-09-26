{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.ray-x.lsp_signature;
in
{
  options.blackmatter.programs.nvim.plugins.ray-x.lsp_signature.enable = mkEnableOption "ray-x/lsp_signature";

  config = mkMerge [
    (mkIf cfg.enable {
      # show function signature
      home.file.".local/share/nvim/site/pack/ray-x/start/lsp_signature.nvim".source =
        builtins.fetchGit {
          url = "https://github.com/ray-x/lsp_signature.nvim";
          ref = "master";
          rev = import ./rev.nix;
        };
    })
  ];
}
