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
  home.username = "luis";
  home.homeDirectory = "/home/luis";
  nixpkgs.config.allowUnfree = true;
  xsession.enable = true;
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.extraConfig = ''
    # Set the Mod key to the Super/Windows key
    set $mod Mod4

    # Start a terminal
    bindsym $mod+Return exec alacritty

    # Exit i3
    bindsym $mod+Shift+e exec "i3-msg exit"

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Restart i3 inplace (preserves your layout/session)
    bindsym $mod+Shift+r restart

    # Move focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # Split in horizontal orientation
    bindsym $mod+Shift+h split h

    # Split in vertical orientation
    bindsym $mod+Shift+v split v

    # Change container layout
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Kill focused window
    bindsym $mod+Shift+q kill

    # Start dmenu (a program launcher)
    bindsym $mod+d exec dmenu_run

    # Volume control (requires appropriate packages)
    bindsym XF86AudioRaiseVolume exec amixer set Master 5%+
    bindsym XF86AudioLowerVolume exec amixer set Master 5%-
    bindsym XF86AudioMute exec amixer set Master toggle

    # Add other configurations as needed
  '';
}
