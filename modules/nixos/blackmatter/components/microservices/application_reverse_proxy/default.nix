{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.microservices.application_reverse_proxy;

  interface = {
    enable = mkOption {
      type = types.bool;
      default = true; # Default for global enable
      description = "Enable application reverse proxy";
    };

    traefik = {
      enable = mkOption {
        type = types.bool;
        default = true; # Default for Traefik enable
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
        default = true; # Default for Consul enable
        description = "Enable Consul service";
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
      # services.traefik = {
      #   enable = true;
      #   package = cfg.traefik.package;
      #   # extraConfig = cfg.traefik.extraConfig;
      #   # serviceConfig = {
      #   #   After = [ "consul.service" ];
      #   #   Requires = [ "consul.service" ];
      #   # };
      # };
    })
    (mkIf (cfg.enable && cfg.consul.enable) {
      blackmatter.components.microservices.consul = {
        enable = true;
      };
    })
  ];
}

