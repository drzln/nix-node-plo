{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = false;
    jack.enable = true;
  };

  hardware.pulseaudio.enable = false; # Disable PulseAudio
  # sound.enable = false; # Disable ALSA handling
}
