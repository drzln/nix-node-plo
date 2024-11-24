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
      kubernetes.enable = mkEnableOption "desktop";

      # provide a monitor configuration
      # desktop.monitors = mkOption {
      #   type = types.attrs;
      #   description = "monitor related attributes";
      # };
    };
  };

  config = mkMerge [
    (mkIf cfg.kubernetes.enable {
      blackmatter.kubernetes.k3d.enable = true;
      home.packages = with pkgs; [
        # k3d
        kind
      ];

      # blackmatter.desktop.kitty.enable = true;
      # blackmatter.desktop.packages.enable = true;
      # blackmatter.desktop.firefox.enable = false;
      # blackmatter.desktop.i3.enable = true;

      #########################################################################
      # vscode
      #########################################################################

      # programs.vscode.enable = false;

      # end vscode

      #########################################################################
      # playin wit some chrome real quick
      #########################################################################
      # programs.chromium.enable = false;
      # programs.chromium.package = pkgs.chromium.overrideAttrs (oldAttrs: {
      #   postInstall = ''
      #     echo '$(echo $preferences | jq -c .)' | tr -d '\n' > $out/Preferences
      #     chmod 600 $out/Preferences
      #     # Copy the modified "Preferences" file to the user's profile directory
      #     cp $out/Preferences $HOME/.config/google-chrome/Default/Preferences
      #   '';
      # });
      # programs.chromium.extensions = [
      #   # nord theme
      #   { id = "honjmojpikfebagfakclmgbcchedenbo"; }
      #   # 1password
      #   { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; }
      # ];
    })
  ];
}
