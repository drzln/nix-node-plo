[
  # (self: super: {
  #   # neovim_raw = super.neovim.overrideAttrs (oldAttrs: rec {
  #   #   version = "0.8.0";
  #   #   src = super.fetchurl {
  #   #     url = "https://github.com/neovim/neovim/releases/download/v${version}/nvim-linux64.tar.gz";
  #   #     sha256 = "sha256-GvJ0cfdvG0961lY8hjpKeBF/BRXjOQ7k2RETKXBRf6c=";
  #   #   };
  #   #   unpackPhase = ''
  #   #     tar xzf $src --strip-components=1
  #   #   '';
  #   # });
  # })



  # overlays/default.nix
  # (self: super: {
  #   neovim_raw = super.neovim.overrideAttrs (oldAttrs: rec {
  #     buildPhase = ''
  #       echo "This build should fail as a test."
  #       exit 1
  #     '';
  #   });
  # })
  (self: super: {
    neovim = super.callPackage ./neovim.nix {};
  })

  # (self: super: {
  #   neovim_raw = super.neovim.overrideAttrs (oldAttrs: rec {
  #     version = "0.100000000.0";
  #     src = super.fetchFromGitHub {
  #       owner = "neovim";
  #       repo = "neovim";
  #       rev = "v${version}";
  #       sha256 = "1szx648cffsaqqnm0j9jy5ibky20nfdzbfd5v7i989pw8f79amwr"; # Replace with actual hash
  #     };
  #     postInstall = ''
  #       echo "Built Neovim version ${version}"
  #   '';
  #   });
  # })
]
