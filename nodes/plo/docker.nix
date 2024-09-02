{...}: {
  systemd.services.docker.serviceConfig = {
    LimitNOFILE = "1048576";
    LimitNPROC = "65536";
    LimitCORE = "infinity";
  };
  systemd.services."*".serviceConfig.limitNOFILE = "1048576";
  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576;
  '';
}
