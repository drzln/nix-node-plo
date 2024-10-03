{
  home.file."code/codecommit/flake.nix" = {
    source = ./code/codecommmit/flake.nix;
  };
  home.file."code/codecommit/.envrc" = {
    text = "use flake";
  };
}
