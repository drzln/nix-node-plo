[
  (self: super: {
    neovim_8 = super.neovim.overrideAttrs (oldAttrs: rec {
      version = "0.8.0";
      src = super.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "v${version}";
        sha256 = "1szx648cffsaqqnm0j9jy5ibky20nfdzbfd5v7i989pw8f79amwr";
      };
    });
  })
]
