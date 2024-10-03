{ config, ... }: {
  sops.secrets."aws/config" = {
    sopsFile = ../../../../secrets/default.yaml;
    path = "/home/luis/.aws/config";
  };
}
