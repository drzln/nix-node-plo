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
    apiInsecure = t.apiInsecure; # dev: keep dashboard open
    webPort = t.webPort; # dev: main traffic on 8080
    apiPort = t.apiPort; # dev: dashboard on 8081
  };

  prodDefaults = {
    logLevel = "INFO";
    apiInsecure = t.apiInsecure; # prod: dashboard off by default
    webPort = t.webPort; # typical HTTP port
    apiPort = t.apiPort; # used if dashboard is enabled
  };

  ##############################################################################
  # 2) Merge user inputs
  ##############################################################################
  #
  # If t.onlyExtra == true, we skip dev/prod defaults (and skip the user’s
  # top-level webPort/apiPort). That means only extraConfig is used.
  #
  # Otherwise, we do the standard dev/prod + extraConfig + user port overrides.
  #
  finalUserInputs =
    if t.onlyExtra then
      mkMerge [
        t.extraConfig
      ]
    else
      mkMerge [
        (if t.mode == "dev" then devDefaults else prodDefaults)
        t.extraConfig
        {
          webPort = t.webPort;
          apiPort = t.apiPort;
        }
      ];

  ##############################################################################
  # 3) Construct a Real Traefik Config from finalUserInputs
  ##############################################################################
  #
  # We do `or` fallback to avoid "attribute missing" errors if the user
  # removes them from extraConfig.

  realTraefikConfig =
    let
      logLevel = finalUserInputs.logLevel    or "INFO";
      apiInsecure = finalUserInputs.apiInsecure or t.apiInsecure;
      webPort = toString (finalUserInputs.webPort or t.webPort);
      apiPort = toString (finalUserInputs.apiPort or t.apiPort);
    in
    {
      # Logging
      log.level = logLevel;

      # If `apiInsecure`, expose the dashboard at :apiPort
      api = if apiInsecure then { insecure = true; } else { };

      # The "entryPoints" map: always have "web" at :webPort
      entryPoints = {
        web = {
          address = ":${webPort}";
        };
      } //
      # If the dashboard is insecure, add "traefik" at :apiPort
      (if apiInsecure then {
        traefik.address = ":${apiPort}";
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

      # NEW: If set to true, we skip dev/prod defaults & port overrides,
      # so only extraConfig is used.
      onlyExtra = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, skip dev/prod defaults entirely. Only extraConfig is used.
          That means ignoring webPort & apiPort top-level options as well.
        '';
      };

      apiInsecure = mkOption {
        type = types.bool;
        default = true;
        description = ''
					whether apiInsecure is turned on and we get a dashboard
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = ''
          Extra user config that merges into dev/prod defaults
          (unless `onlyExtra = true`, in which case it’s the only config).
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
          Main HTTP port for Traefik in dev (80 in prod).
          If `onlyExtra` is true, we ignore this entirely.
        '';
      };

      apiPort = mkOption {
        type = types.int;
        default = 8081;
        description = ''
          Dashboard port if `apiInsecure` is true. Dev default 8081, prod 8080.
          If `onlyExtra` is true, we ignore this entirely.
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
    environment.etc."traefik/traefik.yml".text =
      builtins.toJSON realTraefikConfig;

    # 6b) Systemd service
    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = finalCommand;
    };
  };
}
