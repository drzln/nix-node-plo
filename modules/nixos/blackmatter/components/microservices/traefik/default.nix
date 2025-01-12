{ lib, pkgs, config, ... }:
with lib;

################################################################################
# NixOS Module for Traefik
################################################################################
let
  # Short alias for user config
  t = config.blackmatter.components.microservices.traefik;

  #################################
  # 1) Define Defaults for Each Mode
  #################################
  devDefaults = {
    logLevel = "DEBUG";
    apiInsecure = true; # dev: keep dashboard open
    webPort = t.webPort; # dev: main traffic on 8080
    apiPort = t.apiPort; # dev: dashboard on 8081
  };

  prodDefaults = {
    logLevel = "INFO";
    apiInsecure = false; # prod: dashboard off by default
    webPort = t.webPort; # dev: main traffic on 8080
    apiPort = t.apiPort; # dev: dashboard on 8081
  };

  #######################################################################
  # 2) Merge user inputs (dev/prod defaults + extraConfig + port overrides)
  #######################################################################
  finalUserInputs = mkMerge [
    (if t.mode == "dev" then devDefaults else prodDefaults)
    t.extraConfig
  ];

  ##################################################################
  # 3) Construct a Real Traefik Config from finalUserInputs Safely
  ##################################################################
  #
  # Use `or SOMETHING` so it won't blow up if the user removes or overrides them.

  realTraefikConfig =
    let
      logLevel = finalUserInputs.logLevel    or "INFO";
      apiInsecure = finalUserInputs.apiInsecure or false;
      webPort = toString (finalUserInputs.webPort or t.webPort);
      apiPort = toString (finalUserInputs.apiPort or t.apiPort);
    in
    {
      log.level = logLevel;

      api = if apiInsecure then { insecure = true; } else { };

      entryPoints = {
        # Always define `web` at webPort
        web = {
          address = ":${webPort}";
        };
      } //
      # If apiInsecure == true, define a second entryPoint "traefik" at apiPort
      (if apiInsecure then {
        traefik = {
          address = ":${apiPort}";
        };
      } else { });
    };

  ###################################
  # 4) Build the ExecStart Command
  ###################################
  #
  # By default, just `--configFile=/etc/traefik/traefik.yml`.

  defaultCommand = ''
    "${t.package}/bin/traefik" \
      --configFile=/etc/traefik/traefik.yml
  '';

  finalCommand = if t.command != "" then t.command else defaultCommand;

in
{
  #############################
  # 5) Module Options
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
          Extra user config that merges into dev/prod defaults.
          E.g. `{ apiInsecure = false; }` to forcibly disable the dashboard.
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
        default = 8080;
        description = ''
          Main HTTP port for Traefik. 
          Dev default is 8080, prod default is 80.
        '';
      };

      apiPort = mkOption {
        type = types.int;
        default = 8081;
        description = ''
          Dashboard port, used if `apiInsecure` is true.
          Dev default is 8081, prod default is 8080.
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
    # 6a) Write /etc/traefik/traefik.yml
    # Traefik can parse JSON as if it were YAML, so toJSON is enough.
    environment.etc."traefik/traefik.yml".text = builtins.toJSON realTraefikConfig;

    # 6b) Systemd service
    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = finalCommand;
    };
  };
}

