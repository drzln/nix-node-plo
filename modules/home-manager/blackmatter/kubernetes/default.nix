{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.blackmatter;

in
{
  imports = [
    ./k3d
  ];

  options = {
    blackmatter = {
      kubernetes.enable = mkEnableOption "kubernetes";
    };
  };

  config = mkMerge [
    (mkIf cfg.kubernetes.enable {
      home.packages = with pkgs; [
        kind
        minikube
        helm
        kubectl
      ];
    })
  ];
}
