{ requirements, pkgs, ... }: {
  imports = [
    requirements.outputs.homeManagerModules.blackmatter
  ];
  blackmatter.enable = true;
  blackmatter.profiles.winter.enable = true;
  blackmatter.components.nvim.package = pkgs.neovim_drzln;
  blackmatter.components.desktop.i3.monitors = {
    main = {
      name = "DP-2";
      mode = "1920x1080";
      rate = "360";
    };
  };
  # blackmatter.gitconfig.email = "luis@pleme.io";
  # blackmatter.gitconfig.user = "luis";
  # blackmatter.programs.nvim.enable = true;
  # blackmatter.shell.enable = true;
  # blackmatter.gitconfig.enable = true;
}
