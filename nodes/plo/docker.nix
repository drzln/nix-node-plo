{...}: {
  systemd.services.docker.serviceConfig = {
    LimitNOFILE = "1048576";
    LimitNPROC = "65536";
    LimitSTACK = "infinity";
    LimitMEMLOCK = "infinity";
  };

  systemd.user.services.docker.serviceConfig = {
    LimitNOFILE = "1048576";
    LimitNPROC = "65536";
    LimitSTACK = "infinity";
    LimitMEMLOCK = "infinity";
  };

  # systemd.extraConfig = ''
  #   DefaultLimitNOFILE=1048576
  #   DefaultLimitNPROC=65536
  #   DefaultLimitSTACK=infinity
  #   DefaultLimitMEMLOCK=infinity
  # '';
}
