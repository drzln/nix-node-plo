{ pkgs, ... }: {
  programs.gnupg.agent = {
    enable = true;
    pinentry = pkgs.pinentry-curses;
  };
}
