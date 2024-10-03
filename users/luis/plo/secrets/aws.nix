{ config, ... }: {
  sops = {
    secrets = {
      awsConfig = {
        sopsFile = ./secrets/luis/.aws/config;
      };
    };
  };

  home.file.".aws/config" = {
    text = config.sops.secrets.awsConfig;
    # permissions = "0600";
  };
}
