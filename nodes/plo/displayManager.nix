{ ... }: {
  services.xserver.displayManager.setupCommands = ''
    mkdir -p /etc/sddm/scripts
    echo "#!/bin/sh" > /etc/sddm/scripts/Xsetup
    echo "xrandr --output DP-2 --mode 1920x1080 --rate 360" >> /etc/sddm/scripts/Xsetup
    chmod +x /etc/sddm/scripts/Xsetup
  '';
  services.displayManager = {
    defaultSession = "gnome";
    sddm = {
      enable = true;
      theme = "nord";
      wayland.enable = true;
      extraConfig = ''
        [General]
        HaltCommand=/etc/sddm/scripts/Xsetup
      '';
    };
  };
}
