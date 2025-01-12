{ lib, pkgs, config, ... }:
with lib;

let
  # Short alias for user config.
  t = config.blackmatter.components.microservices.traefik;

  #################################
  # 1) Define Defaults for Each Mode
  #################################
  devDefaults = {
    logLevel    = "DEBUG";
    apiInsecure = true;   # dev: keep dashboard open
    webPort     = 8080;   # dev: traffic on 8080
    apiPort     = 8081;   # dev: dashboard on 8081
  };

  prodDefaults = {
    logLevel    = "INFO";
    apiInsecure = false;  # prod: disable dashboard by default
    webPort     = 80;     # typical HTTP port
    apiPort     = 8080;   # used if dashboard is enabled
  };

  #######################################################################
  # 2) Merge user inputs (dev/prod defaults + extraConfig + port overrides)
  #######################################################################
  finalUserInputs = mkMerge [
    (if t.mode == "dev" then devDefaults else prodDefaults)
    t.extraConfig
    {
      webPort = t.webPort;
      apiPort = t.apiPort;
    }
  ];

  ##################################################################
  # 3) Construct a Real Traefik Config from finalUserInputs Safely
  ##################################################################
  #
  # We rely on finalUserInputs having logLevel, apiInsecure, webPort, apiPort,
  # but we add `or` fallbacks so it won't blow up if something's missing.

  realTraefikConfig = let
    logLevel    = finalUserInputs.logLevel or "INFO";
    apiInsecure = finalUserInputs.apiInsecure or false;
    webPort     = toString (finalUserInputs.webPort or 80);
    apiPort     = toString (finalUserInputs.apiPort or 8080);
  in {
    # Logging
    log = {
      level = logLevel;
    };

    # If `apiInsecure`, define `api.insecure = true`.
    # Otherwise either set `false` or omit the block.
    api = if apiInsecure then { insecure = true; } else {};

    # The "entryPoints" map: always have `web` on `webPort`.
    entryPoints = 
      {
        web = {
          address = ":${webPort}";
        };
      }
      //
      # If the API dashboard is insecurely enabled, define traefik entryPoint
      (if apiInsecure then {
         traefik = {
           address = ":${apiPort}";
         };
       } else {});
  };

  ###################################
  # 4) Build the ExecStart Command(s)
  ###################################
  #
  # By default, just `--configFile=/etc/traefik/traefik.yml`.

  defaultCommand = ''
    "${t.package}/bin/traefik" \
      --configFile=/etc/traefik/traefik.yml
  '';

  # If user sets traefik.command manually, honor that; otherwise, use ours.
  finalCommand = if t.command != "" then t.command else defaultCommand;

in
{
  #############################
  # 5) Module Options Definition
  #############################
  options = {
    blackmatter.components.microservices.traefik = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable the Traefik service.
        '';
      };

      mode = mkOption {
        type = types.enum [ "dev" "prod" ];
        default = "dev";
        description = ''
          Determines dev/prod defaults for logLevel, ports, etc.
        '';
      };

      namespace = mkOption {
        type = types.str;
        default = "default";
        description = ''
          Namespace for the Traefik systemd service name.
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = ''
          Extra user config merged into dev/prod defaults.
          Example: `{ apiInsecure = true; }` to force dashboard on in prod.
        '';
      };

      command = mkOption {
        type = types.str;
        default = "";
        description = ''
          If non-empty, fully override the command to start Traefik.
          Otherwise, we use the file-based approach (`--configFile`).
        '';
      };

      webPort = mkOption {
        type = types.int;
        default = 8080;  # dev default, effectively 80 in prod
        description = ''
          Main HTTP port for Traefik. In dev defaults to 8080, in prod 80.
        '';
      };

      apiPort = mkOption {
        type = types.int;
        default = 8081;  # dev default, effectively 8080 in prod
        description = ''
          Dashboard port (when `apiInsecure` is true).
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = ''
          Which Traefik derivation to use.
        '';
      };
    };
  };

  ################################
  # 6) Module Implementation
  ################################
  config = mkIf t.enable {
    # 6a) Write a file-based config in /etc/traefik/traefik.yml
    #
    # We use builtins.toJSON. Because Traefik/Viper can parse JSON as YAML,
    # it's enough. If you need "true" YAML, use a YAML generator.

    environment.etc."traefik/traefik.yml".text = builtins.toJSON realTraefikConfig;

    # 6b) Create the systemd service
    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy    = [ "multi-user.target" ];
      serviceConfig.ExecStart = finalCommand;

      # Example extra systemd settings
      # serviceConfig = {
      #   Restart = "always";
      # };
    };
  };
}
