{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];
  blackmatter.gitconfig.email = "luis@pleme.io";
  blackmatter.gitconfig.user = "luis";
  blackmatter.desktop.enable = true;
  blackmatter.programs.nvim.enable = true;
  blackmatter.programs.nvim.package = pkgs.neovim_drzln;
  blackmatter.shell.enable = true;
  blackmatter.gitconfig.enable = true;
}
