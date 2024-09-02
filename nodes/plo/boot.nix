{ configs, pkgs, inputs, outputs, ... }: {
  security.selinux.enable = false;
  boot.kernelParams = [ "nvidia-drm.modeset=1" "selinux=0" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
