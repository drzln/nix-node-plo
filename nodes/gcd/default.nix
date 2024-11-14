{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.gnome = {
  #   clocks.enable = true;
  #   calendar.enable = true;
  #   contacts.enable = true;
  #   music.enable = false; # Disable GNOME Music if unnecessary
  #   weather.enable = true;
  # };

  # Input settings (optional)
  # services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,ctrl:nocaps"; # Remap Caps Lock to Control

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
