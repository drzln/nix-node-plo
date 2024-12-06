{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.profiles.blizzard;
in
{
  imports = [
    ./boot
    ./limits
    ./docker
    ./time
    ./locale
    ./xserver
    ./displayManager
    ./virtualisation
    ./bluetooth
    ./sound
		./networking
		./nix
  ];

  options = {
    blackmatter = {
      profiles = {
        blizzard = {
          enable = mkEnableOption "enable the blizzard profile";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable)
      {
        services.printing.enable = false;
        services.hardware.bolt.enable = false;
        services.nfs.server.enable = false;
        security.rtkit.enable = true;
        powerManagement.cpuFreqGovernor = "performance";

        # Enable Wayland hardware acceleration (OpenGL)
        # hardware.opengl.enable = true;

        # Enable seatd for seat/session management, required by Hyprland
        # services.seatd.enable = true;

        # Input device configuration via libinput (Wayland-friendly)
        # services.libinput.enable = true;

        # Choose video drivers if necessary (adjust for your hardware)
        # For Intel:
        # services.xserver.videoDrivers = [ "intel" ];

        # For AMD:
        # services.xserver.videoDrivers = [ "amdgpu" ];

        # For NVIDIA (proprietary):
        # services.xserver.videoDrivers = [ "nvidia" ];

        # Minimal Wayland display manager (greetd) setup
        # services.greetd = {
        #   enable = true;
        #   # Using agreety (simple TUI greeter)
        #   greeter = {
        #     package = pkgs.agreety;
        #   };
        #   defaultSession = "hyprland";
        #   sessions = [
        #     {
        #       name = "hyprland";
        #       command = "${pkgs.hyprland}/bin/Hyprland";
        #     }
        #   ];
        # };

        # Enable pipewire and wireplumber for audio on Wayland
        # services.pipewire = {
        #   enable = true;
        #   alsa.enable = true;
        #   pulse.enable = true;
        # };

        # services.wireplumber.enable = true;

        # Set your preferred login user
        # NOTE: Replace 'your-username' with your actual username
        # users.users.your-username = {
        #   isNormalUser = true;
        #   extraGroups = [ "wheel" "audio" "video" "input" ];
        # };
      })
  ];
}
