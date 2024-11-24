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

    client.enable = mkEnableOption "Enable client tools and KUBECONFIG management for k3d clusters";

    client.tools = mkOption {
      type = types.listOf types.str;
      default = [ "kubectl" "k9s" ];
      description = "List of client tools to install for interacting with Kubernetes clusters.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      k3d
    ] ++ lib.optionals cfg.client.enable (map (tool: pkgs.${tool}) cfg.client.tools);

    home.sessionVariables = lib.mkIf cfg.client.enable {
      KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
    };

    # Setup KUBECONFIG for default and additional clusters
    # home.file = lib.mkIf cfg.client.enable {
    #   ".kube/config".text = builtins.concatStringsSep "\n"
    #     (map
    #       (cluster:
    #         ''
    #           apiVersion: v1
    #           clusters:
    #           - cluster:
    #               server: https://${if cluster.name == "default" then cfg.address else cluster.apiPort}
    #             name: ${cluster.name}
    #           contexts:
    #           - context:
    #               cluster: ${cluster.name}
    #               user: ${cluster.name}-user
    #             name: ${cluster.name}-context
    #           current-context: ${if cluster.name == "default" then "default-context" else cluster.name + "-context"}
    #           users:
    #           - name: ${cluster.name}-user
    #             user:
    #               token: dummy-token-for-${cluster.name}
    #         '')
    #       ([{ name = "default"; apiPort = cfg.address; }] ++ cfg.additionalClusters));
    # };

    # Systemd services for all k3d clusters (default and additional)
    # systemd.user.services = lib.genAttrs
    #   ([{
    #     name = "default";
    #     apiPort = cfg.address;
    #     ports = [ "80:80@loadbalancer" ];
    #   }] ++ cfg.additionalClusters)
    #   (cluster: {
    #     Service = {
    #       ExecStart = ''
    #         ${pkgs.k3d}/bin/k3d cluster create ${if cluster.name == "default" then "" else cluster.name} \
    #           --api-port ${cluster.apiPort} \
    #           ${concatStringsSep " " (map (arg: "-p " + arg) (cluster.ports or []))}
    #       '';
    #       ExecStop = "${pkgs.k3d}/bin/k3d cluster delete ${if cluster.name == "default" then "" else cluster.name}";
    #       Restart = "on-failure";
    #     };
    #     WantedBy = [ "default.target" ];
    #   });
  };
}
