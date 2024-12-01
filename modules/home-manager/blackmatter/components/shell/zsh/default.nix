{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.shell.zsh;
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  options = {
    blackmatter = {
      components = {
        shell.zsh.enable = mkEnableOption "shell.zsh";
        shell.zsh.package = mkOption {
          type = types.package;
          default = pkgs.zsh;
          description = lib.mdDoc ''
            	zsh package to be installed
            	'';
        };
      };
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      programs.zsh.enable = true;
      home.packages = [ cfg.package ];
      home.file.".direnvrc".source = ./direnv/direnvrc.sh;
      xdg.configFile."shellz/rbenv/main.sh".source = ./rbenv/main.sh;
      xdg.configFile."shellz/direnv/main.sh".source = ./direnv/main.sh;
      xdg.configFile."shellz/path/main.sh".source = ./path/main.sh;
      xdg.configFile."shellz/history/main.sh".source = ./history/main.sh;
      xdg.configFile."shellz/sheldon/main.sh".source = ./sheldon/main.sh;
      xdg.configFile."shellz/nix/main.sh".source = ./nix/main.sh;
      xdg.configFile."shellz/tmux/main.sh".source = ./tmux/main.sh;
      xdg.configFile."shellz/ssh_agent/main.sh".source = ./ssh_agent/main.sh;

      programs.zsh.defaultKeymap = "viins";
      programs.zsh.autosuggestion.enable = true;
      programs.zsh.enableCompletion = true;
      programs.zsh.syntaxHighlighting.enable = true;
      programs.zsh.autocd = false;
      programs.zsh.history.size = 10000000;
      programs.zsh.history.save = 10000000;
      programs.zsh.shellAliases = {
        vim = "nvim -u ~/.config/nvim/init.lua";
        vimdiff = "nvim -d -u ~/.config/nvim/init.lua";
        cat = "bat";
      } // lib.optionalAttrs isLinux {
        pbcopy = "xsel --clipboard --input";
        pbpaste = "xsel --clipboard --output";
      };
      programs.zsh.initExtra = builtins.readFile ./zprofile.sh;
      programs.zsh.prezto.enable = false;
      programs.zsh.zplug.enable = false;
    })
  ];

}
