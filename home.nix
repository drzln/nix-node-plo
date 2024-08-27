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
    git-remote-gcrypt
    android-tools
    coreutils-prefixed
    gnirehtet
    jellyfin-ffmpeg
    yq-go
    unzip
    opam
    # yq
    # python3
    mysql
    tfsec
    ruby
    tfplugindocs
    tfswitch
    golint
    duckdb
    docker
    delve
    tree
    yarn
    typescript
    lazydocker
    nixopsUnstable
    postgres_with_libpq
    lazygit
    packer
    twitch-tui
    wiki-tui
    tuir
    dig
    nmap
    spotify-tui
    saml2aws
    tuifeed
    kompose
    gcc
    jdk
    cargo
    dotnet-sdk
    ripgrep
    podman-compose
    tree
    sshfs
    php81Packages.composer
    php81Packages.php-cs-fixer
    xorriso
    traceroute
    iproute2
    s-tui
    usbutils
    sheldon
    julia
    adb-sync
    autoadb
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

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
}
