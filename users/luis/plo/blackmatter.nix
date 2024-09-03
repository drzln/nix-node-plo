{ requirements, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];
  blackmatter.programs.nvim.enable = true;
  # blackmatter.programs.nvim.package = true;
  blackmatter.shell.enable = true;
  blackmatter.gitconfig.enable = false;
  blackmatter.desktop.enable = true;
}
