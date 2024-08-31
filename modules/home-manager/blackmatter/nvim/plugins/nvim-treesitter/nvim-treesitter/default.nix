{ lib, config, outputs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.nvim-treesitter.nvim-treesitter;
  sitePath = ".local/share/nvim/site";
  packPath = "${sitePath}/pack";
  plugPackPath = "${packPath}/nvim-treesitter";
  startPath = "${plugPackPath}/start";
  parsersPath = "${packPath}/parsers/start/parsers/tree-sitter/parser";
  prubyPath = "${parsersPath}/ruby";
  ppythonPath = "${parsersPath}/python";
  pcPath = "${parsersPath}/c";
  tsCPath = "${pcPath}/tree-sitter-c";
in
{
  options = {
    blackmatter = {
      programs = {
        nvim = {
          plugins = {
            nvim-treesitter = {
              nvim-treesitter = {
                enable = mkEnableOption "nvim-treesitter/nvim-treesitter";
                # parsers = mkOption {
                #   description = "packages each representing a built grammar";
                #   type = types.attrsOf types.package;
                #   default = {
                #     # tree-sitter-c-grammar =
                #     #   outputs.packages.x86_64-linux.tree-sitter-c-grammar;
                #     # tree-sitter-ruby-grammar =
                #     #   outputs.packages.x86_64-linux.tree-sitter-ruby-grammar;
                #   };
                # };
              };
            };
          };
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {

      # home.file."${parsersPath}/c.so".source =
      #   "${cfg.parsers.tree-sitter-c-grammar}/parser.so";

      # home.file."${parsersPath}/ruby.so".source =
      #   "${cfg.parsers.tree-sitter-ruby-grammar}/parser.so";

      home.file."${startPath}/nvim-treesitter".source =
        builtins.fetchGit {
          url = "https://github.com/nvim-treesitter/nvim-treesitter.git";
          ref = "master";
          rev = "fd9663acca289598086b7c5a366be8b2fa5d7960";
        };
    })
  ];
}
