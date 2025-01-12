{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.blackmatter.components.microservices.application_reverse_proxy;

  interface = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable application reverse proxy as a whole";
    };

    traefik = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Traefik within the application reverse proxy";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = mdDoc "Traefik binary to use";
      };
    };

    consul = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Consul service within the reverse proxy setup";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.consul;
        description = mdDoc "Consul binary to use";
      };
    };
  };
in
{
  imports = [
    ../consul
  ];

  options = {
    blackmatter = {
      components = {
        microservices = {
          application_reverse_proxy = interface;
        };
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.traefik.enable) {
      services.traefik = {
        enable = true;
        package = cfg.traefik.package;
      };
    })

    # If the top-level reverse proxy + Consul is enabled, configure the lower-tier consul.
    (mkIf (cfg.enable && cfg.consul.enable) {
      blackmatter.components.microservices.consul = {
        enable = true;
        package = cfg.consul.package;
      };
    })
  ];
}
