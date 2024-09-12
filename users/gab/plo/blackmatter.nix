{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];
  blackmatter.programs.nvim.enable = true;
  blackmatter.programs.nvim.package = pkgs.neovim;
  blackmatter.shell.enable = true;
  blackmatter.gitconfig.enable = false;
  blackmatter.desktop.enable = true;
}
