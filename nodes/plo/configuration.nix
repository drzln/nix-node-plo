{ config, pkgs, requirements, ... }:
let
  pkgs-unstable = requirements.inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  system.stateVersion = "24.05";

  # common settings for our sudo users
  sudo-users-common =
    {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "a sudo user";
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


  imports = [
    ./boot.nix
    ./limits.nix
    ./docker.nix
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
    GBM_BACKEND = "nvidia-drm";
  };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  users.users.luis = {
    uid = 1001;
  } // sudo-users-common;

  users.users.gab = {
    uid = 1002;
  } // sudo users-common;

  security.sudo.extraConfig = ''
    luis ALL=(ALL) NOPASSWD:ALL
    gab ALL=(ALL) NOPASSWD:ALL
  '';

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    vim
    wget
    git
    fontconfig
  ];

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

  programs.hyprland.enable = false;
  programs.hyprland.xwayland.enable = false;
  programs.hyprland.package = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  programs.hyprland.portalPackage = requirements.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  services.dbus.enable = true;
  services.udev.enable = true;

  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    dejavu_fonts
  ];
}
