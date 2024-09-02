{...}: {
  systemd.services.docker.serviceConfig = {
    LimitNOFILE = 1048576;
    LimitNPROC = 65536;
    LimitCORE = "infinity";
  };
}
