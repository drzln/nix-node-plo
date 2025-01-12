{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.blackmatter.components.microservices.consul or {};

  # Default settings for dev mode.
  defaultDevConfig = {
    bind_addr = "127.0.0.1";
    server    = false;
    data_dir  = "/tmp/consul";
    ui        = true;
  };

  # Default settings for production mode.
  defaultProdConfig = {
    bind_addr = "0.0.0.0";
    server    = true;
    data_dir  = "/var/lib/consul";
    ui        = false;
  };

in {
  options = {
    blackmatter.components.microservices.consul = {
      enable = mkOption {
        type        = types.bool;
        default     = true;
        description = "Enable consul.";
      };

      mode = mkOption {
        type        = types.enum [ "dev" "prod" ];
        default     = "dev";
        description = "Mode for Consul: 'dev' or 'prod'.";
      };

      namespace = mkOption {
        type        = types.str;
        default     = "default";
        description = "Namespace for the Consul systemd service name.";
      };

      # Allows the user to override or add any arbitrary configuration values
      # that will get merged into the final consul config JSON.
      extraConfig = mkOption {
        type        = types.attrsOf types.anything;
        default     = {};
        description = ''
          Additional config to be merged with the default dev/prod config.
        '';
      };

      # If this is empty, we generate a command automatically based on `mode`.
      # Otherwise, the user can override the entire `consul agent` invocation.
      command = mkOption {
        type        = types.str;
        default     = "";
        description = ''
          Override the default consul command.  
          If empty, this module generates one from `mode` and `extraConfig`.
        '';
      };
    };
  };

  config = let
    # Merge the base dev/prod config with user-supplied overrides.
    baseConfig = if cfg.mode == "dev" then defaultDevConfig else defaultProdConfig;
    consulConfig = mkMerge [ baseConfig cfg.extraConfig ];

    # The final command to start Consul. If 'command' is non-empty, use it directly.
    # Otherwise, generate a mode-appropriate command.
    finalCommand = if cfg.command != "" then cfg.command else (
      if cfg.mode == "dev" then
        # Example dev command
        "${pkgs.consul}/bin/consul agent "
        + "-dev "
        + "-bind=${consulConfig.bind_addr} "
        + "--data-dir=${consulConfig.data_dir} "
        + "--ui"
      else
        # Example prod command
        "${pkgs.consul}/bin/consul agent "
        + "-server "
        + "-bind=${consulConfig.bind_addr} "
        + "-config-dir=/etc/consul.d "
        + "--data-dir=${consulConfig.data_dir}"
    );
  in {
    # Write out the config.json used by Consul. Feel free to customize or rename.
    environment.etc."consul.d/config.json".text = builtins.toJSON consulConfig;

    # Only create the systemd service if `enable = true`.
    systemd.services."${cfg.namespace}-consul" = mkIf cfg.enable {
      description = "${cfg.namespace} Consul service";
      wantedBy    = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = finalCommand;
      };
    };
  };
}
