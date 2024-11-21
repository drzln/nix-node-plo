{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "modsetting" ];
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = false;
  boot.kernelParams = [
    "i915.enable_dpcd_backlight=3"
    "acpi_backlight=vendor"
  ];

  # boot.kernelModules = [ "i915" ];
  boot.kernelModules = [ "video" ];

  # Input settings (optional)
  services.xserver.xkb.options = "eurosign:e,ctrl:nocaps"; # Remap Caps Lock to Control

  # Allow unfree software for proprietary GNOME extensions if needed
  nixpkgs.config.allowUnfree = true;

  # Optional system-wide packages
  environment.systemPackages = with pkgs; [
    mesa
    mesa-demos
    vulkan-loader
    vulkan-tools
    intel-gpu-tools
    # gnomeExtensions
    # gnome-shell
    # gnome-terminal
    # dconf-editor
  ];
}
