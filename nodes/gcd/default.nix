{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = false;

  # Input settings (optional)
  services.xserver.xkb.options = "eurosign:e,ctrl:nocaps"; # Remap Caps Lock to Control

  # Allow unfree software for proprietary GNOME extensions if needed
  nixpkgs.config.allowUnfree = true;

  # Optional system-wide packages
  environment.systemPackages = with pkgs; [
    # gnomeExtensions
    # gnome-shell
    # gnome-terminal
    # dconf-editor
  ];
}
