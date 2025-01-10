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
      # extraConfig = mkOption {
      #   type = types.str;
      #   default = ''
      #     entryPoints:
      #       mysql-entry:
      #         address: ":3306"
      #         tls:
      #           passthrough: true
      #     providers:
      #       file:
      #         directory: /etc/traefik/dynamic/
      #         watch: true
      #   '';
      #   description = "Override the default Traefik configuration";
      # };
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
      # extraConfig = mkOption {
      #   type = types.str;
      #   default = "";
      #   description = "Override or provide additional Consul configuration";
      # };
    };
  };
in
{
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
        # Use user-provided or default Traefik configuration
        # extraConfig = cfg.traefik.extraConfig;
        # serviceConfig = {
        #   After = [ "consul.service" ];
        #   Requires = [ "consul.service" ];
        # };
      };
    })
    (mkIf (cfg.enable && cfg.consul.enable) {
				#   services.consul = {
				#     enable = true;
				#     package = cfg.consul.package;
				# webUi = true;
				# interface.bind = "lo";
				#
				# # if other services use After=consul.service
				# # serviceConfig.Type =  "notify";
				#     # server = {
				#     #   enabled = true;
				#     #   bootstrapExpect = 1;
				#     # };
				#     # For demonstration: assign extraConfig even if not directly used by Consul module
				#     # This field may need special handling depending on how you intend to apply it.
				#     # extraConfig = cfg.consul.extraConfig;
				#   };
    })
  ];
}

