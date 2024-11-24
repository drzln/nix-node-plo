{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];

  blackmatter.kubernetes.enable = true;
}
