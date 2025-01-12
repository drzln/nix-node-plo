{ lib, pkgs, config, ... }:
with lib;

################################################################################
# NixOS Module for Traefik
################################################################################
let
  t = config.blackmatter.components.microservices.traefik;

  defaultSettings = {
    api = {
      insecure = true;
    };
    entryPoints = {
      traefik = {
        address = ":8081";
      };
      web = {
        address = ":8080";
      };
    };
    log = {
      level = "INFO";
    };
  };

  # If the user provides no settings, fall back to `defaultConfig`.
  finalSettings =
    if t.settings == { } then defaultSettings else t.settings;

in
{
  options = {
    blackmatter.components.microservices.traefik = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the Traefik service.";
      };

      namespace = mkOption {
        type = types.str;
        default = "default";
        description = "Namespace for the Traefik systemd service name.";
      };

      settings = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Traefik dynamic settings (overrides defaults if non-empty).";
      };

      command = mkOption {
        type = types.str;
        default = "${pkgs.traefik}/bin/traefik --configFile=/etc/traefik/traefik.yml";
        description = ''
          Command to start Traefik. By default points to the package's binary
          and uses /etc/traefik/traefik.yml.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = "Which Traefik derivation to use.";
      };
    };
  };

  config = mkIf t.enable {
    environment.etc."traefik/traefik.yml".text =
      builtins.toJSON finalSettings;

    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = t.command;
    };
    services.dnsmasq.settings = {
      address = [ "/${t.namespace}-traefik.local/127.0.0.1" ];
    };
  };
}
