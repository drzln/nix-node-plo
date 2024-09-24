{ lib, config, pkgs, ... }:
with lib;
let
  author = "williamboman";
  name = "mason.nvim";
  plugName = "mason";
  url = "https://github.com/${author}/${name}";
  ref = "main";
  rev = "74eac861b013786bf231b204b4ba9a7d380f4bd9";
  plugPath = ".local/share/nvim/site/pack/${author}/start/${name}";
  configPath = ".config/nvim/lua/plugins/config/${author}/${plugName}.lua";
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable =
    mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url; };

      home.file."${configPath}".source = ./config.lua;

      # TODO: move this hack to a more reasonable location
      # mason manages language servers.  Some of the binaries
      # it downloads don't work.  One of these is lua_ls.
      # the approach is then to link to a well known derivation
      # to where mason expects the language server binary to be.
      home.file.".local/share/nvim/mason/packages/lua-language-server/bin/lua-language-server".source =
        "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";
    })
  ];
}
