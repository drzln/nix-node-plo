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
      description = "The address where the k3d cluster is accessible.";
    };

    additionalClusters = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "List of additional k3d clusters to configure.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      k3d # Ensure k3d is installed
    ];

    # Create default k3d cluster if enabled
    systemd.user.services.k3d-default = {
      Service = {
        ExecStart = ''
          ${pkgs.k3d}/bin/k3d cluster create --api-port ${cfg.address} -p 80:80@loadbalancer
        '';
        ExecStop = "${pkgs.k3d}/bin/k3d cluster delete";
        Restart = "on-failure";
      };
      WantedBy = [ "default.target" ];
    };

    # Configure additional clusters
    # systemd.user.services = lib.mkIf (cfg.additionalClusters != [ ]) (lib.genAttrs (map (c: c.name) cfg.additionalClusters) (c: {
    #   Service = {
    #     ExecStart = ''
    #       ${pkgs.k3d}/bin/k3d cluster create ${c.name} --api-port ${c.apiPort} ${concatStringsSep " " (map (arg: "-p " + arg) c.ports or [])}
    #     '';
    #     ExecStop = "${pkgs.k3d}/bin/k3d cluster delete ${c.name}";
    #     Restart = "on-failure";
    #   };
    #   WantedBy = [ "default.target" ];
    # }));
  };
}
