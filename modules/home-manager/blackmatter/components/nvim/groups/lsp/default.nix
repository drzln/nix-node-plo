{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.nvim.plugin.groups.lsp;
in
{
  options.blackmatter.components.nvim.plugin.groups.lsp =
    {
      enable = mkEnableOption "lsp";
    };

  imports = [
    ../../plugins/neovim/nvim-lspconfig
    ../../plugins/williamboman/mason.nvim
    ../../plugins/williamboman/mason-lspconfig.nvim
    ../../plugins/jose-elias-alvarez/null-ls
    ../../plugins/ray-x/lsp_signature.nvim
    ../../plugins/onsails/lspkind.nvim
  ];

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          home.packages = with pkgs; [
            ruby
            gnumake
            rubyPackages.sorbet-runtime
          ];

          blackmatter.components.nvim.plugins =
            {
              jose-elias-alvarez."null-ls.nvim".enable = true;
              neovim.nvim-lspconfig.enable = true;
              williamboman."mason.nvim".enable = true;
              williamboman."mason-lspconfig.nvim".enable = true;
              ray-x."lsp_signature.nvim".enable = true;
              onsails."lspkind.nvim".enable = true;
            };
        }
      )
    ];
}
