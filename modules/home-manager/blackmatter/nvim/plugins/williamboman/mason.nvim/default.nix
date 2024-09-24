{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim.plugins.${author}.${name};
  common = import ../../../common;
  url = "${common.baseRepoUrl}/${author}/${name}";
  plugPath = "${common.basePlugPath}/${author}/start/${name}";
  configPath = "${common.baseConfigPath}/${author}/${plugName}.lua";
  author = "williamboman";
  name = "mason.nvim";
  plugName = "mason";
  ref = "main";
  rev = "74eac861b013786bf231b204b4ba9a7d380f4bd9";
in
{
  options.blackmatter.programs.nvim.plugins.${author}.${name}.enable =
    mkEnableOption "${author}/${name}";

  config = mkMerge [
    (mkIf cfg.enable {
      home.file."${plugPath}".source =
        builtins.fetchGit { inherit ref rev url; };

      home.file."${configPath}".source = ./config.lua;

      # this is done so you always have a language server for
      # lua in which neovim is configured for.
      # TODO: move this hack to a more reasonable location
      # mason manages language servers.  Some of the binaries
      # it downloads don't work.  One of these is lua_ls.
      # the approach is then to link to a well known derivation
      # to where mason expects the language server binary to be.
      home.file."${common.baseMasonPackagesPath}/lua-language-server/bin/lua-language-server".source =
        "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";
    })
  ];
}
