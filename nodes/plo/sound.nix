{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.pulseaudio.enable = false; # Disable PulseAudio
  sound.enable = false; # Disable ALSA handling

}
