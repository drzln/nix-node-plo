{ config, pkgs, requirements, ... }:
let
  pkgs-unstable = requirements.inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  system.stateVersion = "24.05";

  imports = [
    ./boot.nix
    ./time.nix
    ./locale.nix
    ./xserver.nix
    ./displayManager.nix
    ./virtualisation.nix
    ./bluetooth.nix
  ];

  networking.networkmanager.enable = true;
  programs.zsh.enable = true;
  hardware.nvidia.open = false;
  hardware.graphics = {
    enable = true;
    package = pkgs-unstable.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
    ];
  };
  hardware.nvidia.modesetting.enable = true;
  services.libinput = { enable = true; };

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    DISABLE_QT5_COMPAT = "0";
    ANKI_WAYLAND = "1";
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #########################################
    # hyprland support
    #########################################

    # waybar
    # alacritty
    # wofi
    # dunst
    # swaybg
    # swaylock
    # grim
    # slurp
    # wl-clipboard
    # mako

    #nvidia-dkms
    #nvidia-utils
    #lib32-nvidia-utils
    #egl-wayland
    #libnvidia-egl-wayland1
    #libnvidia-egl-gbm1

    # hyprland support
    # nix-index
    # drm_info
    # pciutils
    # tfswitch
    # yarn2nix
    # starship
    # dnsmasq
    # ripgrep
    # weechat
    # gnumake
    # openssh
    # fcitx5
    # bundix
    # cargo
    # arion
    # unzip
    # gnupg
    # lorri
    # nomad
    # vault
    # ruby
    # sddm
    # sway
    # rofi
    # yarn
    # xsel
    # lshw
    # htop
    # nmap
    # stow
    # zlib
    # wget
    # curl
    # gcc
    # age
    # git
    # fzf
    # dig
    # vim
    # vim
    # git
    # gh
    # globalprotect-openconnect
    # traceroute
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

  networking.firewall.enable = false;
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';
  networking.wireless.interfaces = [ "wlp0s20f3" ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprland.package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  programs.hyprland.portalPackage = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  #services.dbus.enable = true;
  #services.udev.enable = true;
}
