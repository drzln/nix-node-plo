{ config, pkgs, requirements, ... }:

{
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
    # ../../modules/home-manager/blackmatter
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "luis";
  home.homeDirectory = "/home/luis";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    vim
    git
    git-remote-gcrypt
    android-tools
    gnirehtet
    jellyfin-ffmpeg
    yq-go
    unzip
    opam
    python3
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
    # rnix-lsp
    # nixopsUnstable
    # postgres_with_libpq
    lazygit
    packer
    twitch-tui
    wiki-tui
    tuir
    dig
    nmap
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
    python39Packages.pipenv-poetry-migrate
    python39Packages.poetry-core
    black
    pipenv
    poetry
    asmfmt
    zlib
    ssm-session-manager-plugin
    cloud-nuke
    nodejs
    nodePackages_latest.cdktf-cli
    awscli2
    goreleaser
    go-task
    gofumpt
    gobang
    go
    terraform-ls
    tflint
    terraform-docs
    terraform-landscape
    terraform-compliance
    kubectl
    sumneko-lua-language-server
    luarocks
    lua
    php
    redis-dump
    redis
    redli
    solargraph
    rbenv
    cargo-edit
    rust-code-analysis
    rust-analyzer
    rust-script
    rustic-rs
    rust-motd
    rusty-man
    rustscan
    rustfmt
    rustcat
    rustc
    sops
    age
    shfmt
    tealdeer
    himalaya
    tree-sitter
    yt-dlp
    transmission_4
    xorg.xrandr
    tig
    grex
    gdb
    bat
    feh
    fd
    sd
    hyperfine
    bandwhich
    json2hcl
    node2nix
    cpulimit
    nushell
    ansible
    openssl
    gradle
    trunk
    whois
    delta
    tokei
    tree-sitter
    zoxide
    httpie
    xclip
    procs
  ] ++
  # desktop packages
  [
    _1password-gui
    google-chrome
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
  programs.zsh = {
    enable = true;
  };

  blackmatter.programs.nvim.enable = true;
  blackmatter.shell.enable = true;
  blackmatter.gitconfig.enable = false;
  blackmatter.desktop.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}