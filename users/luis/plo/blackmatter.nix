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
  blackmatter.components.gitconfig.email = "luis@pleme.io";
  blackmatter.components.gitconfig.user = "luis";
  blackmatter.components.gitconfig.enable = true;
  blackmatter.components.kubernetes.enable = false;
  blackmatter.components.kubernetes.k3d.enable = false;
  blackmatter.components.kubernetes.k3d.client.enable = false;
}
