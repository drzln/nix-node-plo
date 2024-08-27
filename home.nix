{ config, pkgs, ... }:

{
  home.username = "luis"; # Replace with your actual username
  home.homeDirectory = "/home/luis"; # Replace with your home directory

  # Set the state version to match Home Manager version
  home.stateVersion = "24.05"; # Use the correct version for your setup

  # Enable some basic packages
  home.packages = with pkgs; [
    vim
    git
  ];

  home.file."backgrounds/nord/tools".source = builtins.fetchGit {
    url = "https://github.com/arcticicestudio/nord.git";
    ref = "develop";
    rev = "c93f12b23baac69a92e7559f69e7a60c20b9da0d";
  };
  home.file."backgrounds/nord/backgrounds".source = builtins.fetchGit {
    url = "https://github.com/dxnst/nord-backgrounds.git";
    ref = "main";
    rev = "c47d6b8b0ea391fabbb79aa005703ae5549ffdc4";
  };
}
