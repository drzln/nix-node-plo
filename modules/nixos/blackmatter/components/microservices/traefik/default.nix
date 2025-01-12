{ lib, pkgs, config, ... }:
with lib;

let
  # Alias for your Traefik config
  t = config.blackmatter.components.microservices.traefik;

  # Defaults for development mode (example)
  devDefaults = {
    logLevel = "DEBUG";
    apiInsecure = true;
    # ... any other dev-specific settings
  };

  # Defaults for production mode (example)
  prodDefaults = {
    logLevel = "INFO";
    apiInsecure = false;
    # ... any other prod-specific settings
  };

  # Merge dev/prod defaults with any user-supplied config
  finalTraefikConfig = mkMerge [
    (if t.mode == "dev" then devDefaults else prodDefaults)
    t.extraConfig
    # If you want to unify everything in one big config structure,
    # you can combine it here. For instance, if you have "port" or
    # "entryPoints" to merge, do so below or in extraConfig.
    {
      # If you have a notion of a main HTTP port for Traefik, you can store it here:
      port = t.port;
    }
  ];

  # Helper to safely get an attribute from finalTraefikConfig or use a fallback
  get = name: fallback:
    if finalTraefikConfig ? name then finalTraefikConfig.${name} else fallback;

  # Default dev command (example flags — adjust as needed)
  defaultDevCommand = ''
    ${t.package}/bin/traefik \
      --log.level=${get "logLevel" "DEBUG"} \
      --api.insecure=${if get "apiInsecure" true then "true" else "false"} \
      --entryPoints.web.address=":${toString t.port}"
  '';

  # Default prod command (example flags — adjust as needed)
  defaultProdCommand = ''
    ${t.package}/bin/traefik \
      --log.level=${get "logLevel" "INFO"} \
      --api.insecure=${if get "apiInsecure" false then "true" else "false"} \
      --entryPoints.web.address=":${toString t.port}"
  '';

  # Final command line (honor user override if provided)
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
        description = "Traefik mode: 'dev' or 'prod'.";
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

      port = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          Primary HTTP port on which Traefik listens.
          By default, this is 8080.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.traefik;
        description = ''
          The Traefik derivation to use. Defaults to the system's "pkgs.traefik".
        '';
      };
    };
  };

  #########################
  # Module Implementation #
  #########################
  config = mkIf t.enable {
    # If you need to generate a config file (TOML/YAML),
    # you could do something like:
    #
    # environment.etc."traefik/traefik.yml".text = builtins.toJSON finalTraefikConfig;
    #
    # or produce TOML, depending on how you prefer to configure Traefik.

    # Create systemd service for Traefik
    systemd.services."${t.namespace}-traefik" = {
      description = "${t.namespace} Traefik Service";
      wantedBy = [ "multi-user.target" ];

      # The command to execute (ExecStart)
      serviceConfig.ExecStart = finalCommand;

      # If you need or want to set other systemd directives, do so here.
      # e.g. serviceConfig = {
      #   Restart = "always";
      #   ...
      # };
    };
  };
}

