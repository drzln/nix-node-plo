{ lib, ... }: {
  home.activation.createCodeCommitDir = lib.mkAfter ''
    		mkdir -p $HOME/code/codecommit
    		chmod 700 $HOME/code/codecommit
    	'';

  home.file."code/codecommit/flake.nix" = {
    source = ./code/codecommit/flake.nix;
  };

  home.file."code/codecommit/.envrc" = {
    text = "use flake";
  };
}
