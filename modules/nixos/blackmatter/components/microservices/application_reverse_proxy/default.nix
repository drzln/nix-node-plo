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
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Traefik dynamic settings (overrides defaults if non-empty).";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = mdDoc "Traefik binary to use";
      };
      namespace = mkOption {
        type = types.str;
        default = "default";
        description = mdDoc ''
          Namespace to use for the consul systemd service name. 
          Defaults to "default".
        '';
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
      namespace = mkOption {
        type = types.str;
        default = "default";
        description = mdDoc ''
          Namespace to use for the traefik systemd service name. 
          Defaults to "default".
        '';
      };
    };
  };
in
{
  imports = [
    ../consul
    ../traefik
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
      blackmatter.components.microservices.traefik = {
        enable = cfg.traefik.enable;
        package = cfg.traefik.package;
        namespace = cfg.traefik.namespace;
        settings = cfg.traefik.settings;
      };
    })

    (mkIf (cfg.enable && cfg.consul.enable) {
      blackmatter.components.microservices.consul = {
        enable = cfg.consul.enable;
        package = cfg.consul.package;
        namespace = cfg.consul.namespace;
      };
    })
  ];
}

