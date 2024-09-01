{ ... }: {
  services.displayManager = {
    defaultSession = "gnome";
    sddm = {
      enable = false;
      theme = "nord";
      wayland.enable = true;
    };
  };
}
