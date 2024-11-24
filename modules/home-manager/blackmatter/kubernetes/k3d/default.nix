{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.blackmatter.kubernetes.k3d;
in
{
  options.blackmatter.kubernetes.k3d = {
    enable = mkEnableOption "k3d for local Kubernetes clusters";

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The address where the default k3d cluster is accessible.";
    };

    additionalClusters = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [ ];
      description = "List of additional k3d clusters to configure. Each entry must have 'name', 'apiPort', and optional 'ports'.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      k3d # Ensure k3d is installed
    ];

    # Systemd services for all k3d clusters (default and additional)
    systemd.user.services = lib.genAttrs
      ([{
        name = "default";
        apiPort = cfg.address;
        ports = [ "80:80@loadbalancer" ];
      }] ++ cfg.additionalClusters)
      (cluster: {
        Service = {
          ExecStart = ''
            ${pkgs.k3d}/bin/k3d cluster create ${if cluster.name == "default" then "" else cluster.name} \
              --api-port ${cluster.apiPort} \
              ${concatStringsSep " " (map (arg: "-p " + arg) (cluster.ports or []))}
          '';
          ExecStop = "${pkgs.k3d}/bin/k3d cluster delete ${if cluster.name == "default" then "" else cluster.name}";
          Restart = "on-failure";
        };
        WantedBy = [ "default.target" ];
      });
  };
}
