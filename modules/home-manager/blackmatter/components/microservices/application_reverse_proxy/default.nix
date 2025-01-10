{ config, pkgs, ... }:
{
  services.traefik = {
    enable = true;
    package = pkgs.traefik;
    extraConfig = ''
      	entryPoints:
      		mysql-entry:
      			address: ":3306"
      			tls:
      				passthrough: true
      	providers:
      		file:
      			directory: /etc/traefik/dynamic/
      			watch: true
    '';
    serviceConfig = {
      After = [ "consul.service" ];
      Requires = [ "consul.service" ];
    };
  };

  services.consul = {
    enable = true;
    package = pkgs.consul;
    server = {
      enabled = true;
      bootstrapExpect = 1;
    };
  };
}
