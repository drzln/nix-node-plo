{ ... }: {
  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      theme = "nord";
      wayland.enable = true;
    };
  };
}
