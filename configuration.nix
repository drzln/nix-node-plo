{ config, pkgs, outputs, ... }:
{
  hardware.nvidia.open = true;
  # hardware.graphics = {
  #   package = pkgs-unstable.mesa.drivers;
  #
  #   # if you also want 32-bit support (e.g for Steam)
  #   enable32Bit = true;
  #   package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  # };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Fortaleza";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.libinput = { enable = true; };
  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      theme = "nord";
      wayland.enable = true;
    };
  };

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  services.xserver = {
    enable = false;
    xkb = {
      options = "caps:escape";
      layout = "us";
      variant = "";
    };
    displayManager = {
      gdm = {
        enable = false;
        wayland = false;
      };
      lightdm = {
        enable = false;
      };
    };
    autoRepeatDelay = 135;
    autoRepeatInterval = 40;
    videoDrivers = [ "nvidia" "intel" "nouveau" "qxl" "amdgpu" ];
    desktopManager = {
      gnome = {
        enable = true;
      };
      xterm = {
        enable = false;
      };
    };
    windowManager = {
      leftwm = { enable = false; };
      i3 = {
        enable = false;
        extraPackages = with pkgs; [
          i3blocks
          i3status
          i3lock
          dmenu
        ];
      };
    };
  };

  programs.zsh.enable = true;
  users.users.luis = {
    uid = 1001;
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "luis";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "podman"
      "libvirtd"
      "audio"
      "video"
    ];
    packages = with pkgs; [
      home-manager
    ];
  };
  security.sudo.extraConfig = ''
    luis ALL=(ALL) NOPASSWD:ALL
  '';

  home-manager.users.luis = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #########################################
    # hyprland support
    #########################################

    waybar
    alacritty
    wofi
    dunst
    swaybg
    swaylock
    grim
    slurp
    wl-clipboard
    mako

    #nvidia-dkms
    #nvidia-utils
    #lib32-nvidia-utils
    #egl-wayland
    #libnvidia-egl-wayland1
    #libnvidia-egl-gbm1

    # hyprland support
    nix-index
    drm_info
    pciutils
    tfswitch
    yarn2nix
    starship
    dnsmasq
    ripgrep
    weechat
    gnumake
    openssh
    fcitx5
    bundix
    cargo
    arion
    unzip
    gnupg
    lorri
    nomad
    vault
    ruby
    sddm
    sway
    rofi
    yarn
    xsel
    lshw
    htop
    nmap
    stow
    zlib
    wget
    curl
    gcc
    age
    git
    fzf
    dig
    vim
    vim
    git
    gh
    globalprotect-openconnect
    traceroute
    vim
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.openssh.settings.PasswordAuthentication = true;
  services.dnsmasq.enable = true;
  services.dnsmasq.settings.server = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
  services.blueman.enable = true;
  services.printing.enable = false;
  services.hardware.bolt.enable = false;
  services.nfs.server.enable = false;
  services.pipewire.enable = true;

  security.rtkit.enable = true;

  fonts.packages = with pkgs;[
    fira-code
    fira-code-symbols
  ];

  powerManagement.cpuFreqGovernor = "performance";

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (4096 * 1024 * 1024)}
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    package = pkgs.nixFlakes;
  };

  console = { font = "Lat2-Terminus16"; keyMap = "us"; };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';
  networking.wireless.interfaces = [ "wlp0s20f3" ];

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  virtualisation.docker.enable = false;
  virtualisation.docker.rootless = {
    setSocketVariable = true;
    enable = true;
  };
  virtualisation.libvirtd.enable = true;

  # programs.kitty.enable = false;
  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  # programs.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  services.dbus.enable = true;
  services.udev.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
