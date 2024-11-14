{ pkgs, ... }:
{
  imports = [
    ./programs.nix
    ./packages.nix
    ./background.nix
    ./hyprland.nix
    ./blackmatter.nix
  ];

  home.stateVersion = "24.05";
  home.username = "gabrielad";
  home.homeDirectory = "/home/gabrielad";

  # Enable XSession and configure GNOME as the window manager
  xsession.enable = true;
  xsession.windowManager.gnome.enable = true;

  # Enable dmenu for application launching
  programs.dmenu.enable = true;

  # Customize GNOME settings, including keybindings
  programs.dconf.enable = true;
  programs.dconf.settings = {
    "/org/gnome/desktop/interface" = {
      # Use dark theme for GTK applications
      "gtk-theme" = "Adwaita-dark";

      # Set Papirus-Dark as the icon theme
      "icon-theme" = "Papirus-Dark";

      # Use the default cursor theme
      "cursor-theme" = "Adwaita";
    };
    "/org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      # Shortcut: Super (Windows key) + d
      "binding" = "<Super>d";

      # Open the application menu (dmenu)
      "command" = "dmenu_run";

      # Program launcher name
      "name" = "Program Launcher (dmenu)";
    };
  };

  # Configure GPG for secure encryption and signing
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-curses;
  services.gpg-agent.extraConfig = ''
    # Cache passphrases for 600 seconds (10 minutes)
    default-cache-ttl 600

    # Allow caching for up to 7200 seconds (2 hours)
    max-cache-ttl 7200
  '';
}

