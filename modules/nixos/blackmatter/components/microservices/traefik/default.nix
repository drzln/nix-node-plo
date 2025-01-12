{ lib, pkgs, config, ... }:
with lib;

let
  # Short alias for the user config
  t = config.blackmatter.components.microservices.traefik;

  ##########################
  # 1) Default mode configs
  ##########################

  # Dev defaults (example)
  devDefaults = {
    logLevel = "DEBUG";
    apiInsecure = true; # enables the dashboard
    webPort = 8080;
    apiPort = 8081;
  };

  # Prod defaults (example)
  prodDefaults = {
    logLevel = "INFO";
    apiInsecure = false; # disables the dashboard by default
    webPort = 80;
    apiPort = 8080;
  };

  ######################################
  # 2) Merge final Traefik configuration
  ######################################

  finalTraefikConfig = mkMerge [
    (if t.mode == "dev" then devDefaults else prodDefaults)
    t.extraConfig
    {
      # Let user override or confirm the final ports:
      webPort = t.webPort;
      apiPort = t.apiPort;
    }
  ];

  # Helper to safely get an attribute from finalTraefikConfig or use fallback
  get = name: fallback:
    if finalTraefikConfig ? name then finalTraefikConfig.${name} else fallback;

  ######################################
  # 3) Build the final ExecStart command
  ######################################

  # For dev or prod, we rely on the merged config to set ports + log level.

  defaultDevCommand = ''
    ${t.package}/bin/traefik \
      --log.level=${get "logLevel" "DEBUG"} \
      ${if get "apiInsecure" true then ''
        --api.insecure=true \
        --entryPoints.traefik.address=":${toString (get "apiPort" 8081)}"
      '' else ''
        --api.insecure=false
      ''} \
      --entryPoints.web.address=":${toString (get "webPort" 8080)}"
  '';

  defaultProdCommand = ''
    ${t.package}/bin/traefik \
      --log.level=${get "logLevel" "INFO"} \
      ${if get "apiInsecure" false then ''
        --api.insecure=true \
        --entryPoints.traefik.address=":${toString (get "apiPort" 8080)}"
      '' else ''
        --api.insecure=false
      ''} \
      --entryPoints.web.address=":${toString (get "webPort" 80)}"
  '';

  # If user sets traefik.command manually, honor that.
  # Otherwise pick dev or prod default.
  finalCommand =
    if t.command != "" then
      t.command
    else if t.mode == "dev" then
      defaultDevCommand
    else
      defaultProdCommand;

in
{
  ##############################
  # Module Options Definition #
  ##############################
  options = {
    blackmatter.components.microservices.traefik = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Traefik service.";
      };

      mode = mkOption {
        type = types.enum [ "dev" "prod" ];
        default = "dev";
        description = "Traefik mode: 'dev' or 'prod'. Determines defaults like ports, logLevel, etc.";
      };

      namespace = mkOption {
        type = types.str;
        default = "default";
        description = "Namespace for the Traefik systemd service name.";
      };

      extraConfig = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = ''
          Extra Traefik configuration (merged into dev/prod defaults).
          This might be used for additional command-line flags, or
          generating a traefik.toml/traefik.yml, etc.
        '';
      };

      command = mkOption {
        type = types.str;
        default = "";
        description = ''
          If non-empty, completely override the command to start Traefik.
          Otherwise, a dev/prod-appropriate default is used.
        '';
      };

      ####################
      # NEW: Separate Ports
      ####################
      webPort = mkOption {
        type = types.int;
        # Note: The dev/prod default merges from devDefaults/prodDefaults,
        # but if the user sets this top-level, it takes precedence.
        default = 8080;
        description = ''
          Primary "web" port for user-facing HTTP traffic.
          Defaults to 8080 in dev, 80 in production,
          but you can override it if desired.
        '';
      };

      apiPort = mkOption {
        type = types.int;
        default = 8081;
        description = ''
          "Dashboard" / "Traefik" port, used if "apiInsecure = true".
          Defaults to 8081 in dev, 8080 in production, but can be overridden.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = ''
          The traefik derivation to use. Defaults to the system's "pkgs.traefik".
        '';
      };

      ############################
      # Still from dev/prod logic
      ############################
      # `apiInsecure` is read from dev/prod defaults,
      # but if you want to override it at the top level, you can do so:
      #   blackmatter.components.microservices.traefik.extraConfig = {
      #     apiInsecure = true; # or false
      #   };
      #
      # Or you can add a direct option here if desired. For example:
      #
      # apiInsecure = mkOption {
      #   type = types.bool;
      #   default = false;
      #   description = "Enable insecure API / Dashboard on 'apiPort'.";
      # };
      #
      # Then add that to your finalTraefikConfig merges. 
    };
  };

  #########################
  # Module Implementation #
  #########################
  config = mkIf t.enable {
    # Optionally generate a config file (TOML/YAML/JSON) if you prefer a file-based config:
    #
    # environment.etc."traefik/traefik.yml".text = builtins.toJSON finalTraefikConfig;
    #
    # Then your ExecStart could reference it via:
    #   --configFile=/etc/traefik/traefik.yml

    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = finalCommand;

      # Additional systemd settings if needed (Restart, etc.)
      # serviceConfig = {
      #   Restart = "always";
      # };
    };
  };
}
