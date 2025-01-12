{ lib, pkgs, config, ... }:
with lib;

let
  ##############################
  # Short alias for user config
  ##############################
  t = config.blackmatter.components.microservices.traefik;

  #################################
  # 1) Define Defaults for Each Mode
  #################################

  # Development defaults
  devDefaults = {
    logLevel = "DEBUG";
    apiInsecure = true; # dev: keep dashboard open
    webPort = 8080; # dev: user HTTP on 8080
    apiPort = 8081; # dev: dashboard on 8081
  };

  # Production defaults
  prodDefaults = {
    logLevel = "INFO";
    apiInsecure = false; # prod: disable dashboard by default
    webPort = 80; # typical HTTP port
    apiPort = 8080; # if dashboard is enabled
  };

  #####################################
  # 2) Merge Final Traefik Configuration
  #####################################
  finalTraefikConfig = mkMerge [
    (if t.mode == "dev" then devDefaults else prodDefaults)
    t.extraConfig
    {
      # Let user override or confirm final ports
      webPort = t.webPort;
      apiPort = t.apiPort;
    }
  ];

  # Helper to safely get an attr from finalTraefikConfig or use fallback
  get = name: fallback:
    if finalTraefikConfig ? name then
      finalTraefikConfig.${name}
    else
      fallback;

  # Convenience accessors
  logLevel = get "logLevel" "INFO";
  apiInsecure = get "apiInsecure" false;
  webPortVal = toString (get "webPort" 80);
  apiPortVal = toString (get "apiPort" 8080);

  ###################################
  # 3) Build the ExecStart Command(s)
  ###################################
  #
  # We use shell backslashes to ensure systemd sees it as a single command.

  defaultDevCommand = ''
    "${t.package}/bin/traefik" \
      --log.level="${logLevel}" \
      ${if apiInsecure then ''
        --api.insecure=true \
        --entryPoints.traefik.address=":'${apiPortVal}'"
      '' else ''
        --api.insecure=false
      ''} \
      --entryPoints.web.address=":'${webPortVal}'"
  '';

  defaultProdCommand = ''
    "${t.package}/bin/traefik" \
      --log.level="${logLevel}" \
      ${if apiInsecure then ''
        --api.insecure=true \
        --entryPoints.traefik.address=":'${apiPortVal}'"
      '' else ''
        --api.insecure=false
      ''} \
      --entryPoints.web.address=":'${webPortVal}'"
  '';

  # Honor user override if provided; otherwise pick dev or prod default
  finalCommand =
    if t.command != "" then
      t.command
    else if t.mode == "dev" then
      defaultDevCommand
    else
      defaultProdCommand;

in
{
  ################################
  # 4) Module Options Definition #
  ################################
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
          Determines dev/prod defaults for logLevel, ports, and the dashboard.
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
          Extra configuration merged into dev/prod defaults (for advanced flags).
          E.g. `{ apiInsecure = true; }` to force dashboard on in prod.
        '';
      };

      command = mkOption {
        type = types.str;
        default = "";
        description = ''
          If non-empty, fully override the command to start Traefik.
          Otherwise, the dev/prod default is used.
        '';
      };

      # Ports
      webPort = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          Main HTTP port for Traefik. In dev defaults to 8080, in prod to 80.
          Override as needed.
        '';
      };

      apiPort = mkOption {
        type = types.int;
        default = 8081;
        description = ''
          Dashboard port (when apiInsecure is true).
          In dev defaults to 8081, in prod to 8080, unless overridden.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = ''
          Traefik derivation to use. Defaults to the system's pkgs.traefik.
        '';
      };
    };
  };

  ############################
  # 5) Module Implementation #
  ############################
  config = mkIf t.enable {
    # Optionally, generate a config file:
    # environment.etc."traefik/traefik.yml".text = builtins.toJSON finalTraefikConfig;
    # Then reference it with: --configFile=/etc/traefik/traefik.yml

    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = finalCommand;

      # Optionally set more systemd options, e.g.:
      # serviceConfig = {
      #   Restart = "always";
      # };
    };
  };
}
