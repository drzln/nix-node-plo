{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];
  blackmatter.programs.nvim.enable = false;
  # blackmatter.programs.nvim.package = pkgs.neovim_8;
  blackmatter.shell.enable = true;
  blackmatter.gitconfig.enable = false;
  blackmatter.desktop.enable = true;
}
