{ ... }: {
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  virtualisation.docker.enable = false;
  virtualisation.docker.rootless = {
    setSocketVariable = true;
    enable = true;
  };
  virtualisation.libvirtd.enable = true;
}
