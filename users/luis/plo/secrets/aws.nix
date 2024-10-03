{
  sops = {
    secrets = {
      awsConfig = {
        sopsFile = ./secrets/luis/.aws/config;
      };
    };
  };

  home.file.".aws/config" = {
    text = config.sops.secrets.awsConfig;
    mkdir = true;
    permissions = "0600";
  };
}
