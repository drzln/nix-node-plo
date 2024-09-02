{ ... }: {
  services.displayManager = {
    defaultSession = "gnome";
    sddm = {
      enable = true;
      theme = "nord";
      wayland.enable = true;
    };
  };
}
