{ configs, pkgs, inputs, outputs, ... }: {
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
