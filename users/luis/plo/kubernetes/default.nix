{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];

  blackmatter.kubernetes.enable = true;
  blackmatter.kubernetes.k3d.enable = true;
  blackmatter.kubernetes.k3d.client.enable = true;
}
