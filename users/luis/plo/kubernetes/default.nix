{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];

  blackmatter.kubernetes.enable = true;
  blackmatter.kubernetes.k3d.enable = false;
  blackmatter.kubernetes.k3d.client.enable = false;
}
