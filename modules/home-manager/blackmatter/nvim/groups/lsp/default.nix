{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugin.groups.lsp;
in
{
  options.blackmatter.programs.nvim.plugin.groups.lsp =
    {
      enable = mkEnableOption "lsp";
    };

  imports = [
    ../../plugins/neovim/nvim-lspconfig
    ../../plugins/williamboman/mason.nvim
    ../../plugins/williamboman/mason-lspconfig.nvim
    ../../plugins/jose-elias-alvarez/null-ls
    ../../plugins/ray-x/lsp_signature
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

          blackmatter.programs.nvim.plugins =
            {
              neovim.nvim-lspconfig.enable = true;
              williamboman."mason.nvim".enable = true;
              williamboman."mason-lspconfig.nvim".enable = true;
              jose-elias-alvarez.null-ls.enable = false;
              ray-x.lsp_signature.enable = false;
              onsails."lspkind.nvim".enable = false;
            };
        }
      )
    ];
}