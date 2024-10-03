{ config, ... }: {
  sops.secrets."aws/config" = {
    sopsFile = ../../../../secrets/luis/.aws/config;
    path = "/home/luis/.aws/config";
  };
}
