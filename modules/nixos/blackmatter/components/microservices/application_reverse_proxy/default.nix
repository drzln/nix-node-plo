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
      # Optionally add more consul-related config here if you want
      # to pass them along (e.g. port, mode, extraConfig, etc.)
    };
  };
in
{
  imports = [
    # Import the existing consul module that defines
    # blackmatter.components.microservices.consul
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
    # If the top-level reverse proxy + Traefik is enabled, configure Traefik.
    (mkIf (cfg.enable && cfg.traefik.enable) {
      # Example: If you had a Traefik module, you’d pass the package here:
      # services.traefik = {
      #   enable = true;
      #   package = cfg.traefik.package;
      #   ...
      # };
    })

    # If the top-level reverse proxy + Consul is enabled, configure the lower-tier consul.
    (mkIf (cfg.enable && cfg.consul.enable) {
      blackmatter.components.microservices.consul = {
        enable = true;
        package = cfg.consul.package;
        # If you want to pass additional settings to the lower-tier consul,
        # like port or mode, you can do that here. For example:
        #
        # mode = "prod";           # or something else
        # port = 8500;            # or something else
        # extraConfig = { ... };  # etc.
      };
    })
  ];
}
