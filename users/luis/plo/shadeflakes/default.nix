{ lib, ... }: {
  home.activation.createCodeCommitDir = lib.mkAfter ''
    		mkdir -p $HOME/code/codecommit
    		chmod 700 $HOME/code/codecommit
    	'';

  home.file."code/codecommit/shadeflake.nix" = {
    source = ./code/codecommit/flake.nix;
  };

  home.file."code/codecommit/.envrc" = {
    source = ./code/codecommit/.envrc;
  };
}
