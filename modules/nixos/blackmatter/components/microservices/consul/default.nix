{ lib, pkgs, config, ... }:
with lib;

let
  c = config.blackmatter.components.microservices.consul;

  devDefaults = {
    bind_addr = "127.0.0.1";
    server    = false;
    data_dir  = "/tmp/consul";
    ui        = true;
  };

  prodDefaults = {
    bind_addr = "0.0.0.0";
    server    = true;
    data_dir  = "/var/lib/consul";
    ui        = false;
  };

  # Merge user config with dev/prod defaults
  finalConsulConfig = mkMerge [
    (if c.mode == "dev" then devDefaults else prodDefaults)
    c.extraConfig
  ];

  # Helper to safely get an attribute or use a fallback
  get = name: fallback:
    if finalConsulConfig ? name then finalConsulConfig.${name} else fallback;

  # Default dev command
  defaultDevCommand = ''
    ${pkgs.consul}/bin/consul agent -dev \
      -bind=${get "bind_addr" "127.0.0.1"} \
      --data-dir=${get "data_dir" "/tmp/consul"} \
      --ui
  '';

  # Default prod command
  defaultProdCommand = ''
    ${pkgs.consul}/bin/consul agent -server \
      -bind=${get "bind_addr" "0.0.0.0"} \
      -config-dir=/etc/consul.d \
      --data-dir=${get "data_dir" "/var/lib/consul"}
  '';

  finalCommand = if c.command != "" then
    c.command
  else if c.mode == "dev" then
    defaultDevCommand
  else
    defaultProdCommand;

in {
  options = {
    blackmatter.components.microservices.consul = {
      enable = mkOption {
        type    = types.bool;
        default = true;
        description = "Enable Consul service.";
      };

      mode = mkOption {
        type    = types.enum [ "dev" "prod" ];
        default = "dev";
        description = "Consul mode: 'dev' or 'prod'.";
      };

      namespace = mkOption {
        type    = types.str;
        default = "default";
        description = "Namespace for the Consul systemd service name.";
      };

      extraConfig = mkOption {
        type    = types.attrsOf types.anything;
        default = {};
        description = "Extra Consul configuration merged into dev/prod defaults.";
      };

      command = mkOption {
        type    = types.str;
        default = "";
        description = ''
          If non-empty, completely override the command to start Consul.
          Otherwise, a dev/prod-appropriate default is used.
        '';
      };
    };
  };

  config = mkIf c.enable {
    environment.etc."consul.d/config.json".text = builtins.toJSON finalConsulConfig;

    systemd.services."${c.namespace}_consul" = {
      description = "${c.namespace} Consul Service";
      wantedBy    = [ "multi-user.target" ];
      serviceConfig.ExecStart = finalCommand;
    };
  };
}
