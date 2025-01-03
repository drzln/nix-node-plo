[
  (self: super: {
    neovim_drzln = super.callPackage ../packages/neovim { };
  })
  (self: super: {
    cb = super.buildGoPackage rec {
      pname = "cb";
      version = "1.0.0";

      src = super.fetchFromGitHub {
        owner = "niedzielski";
        repo = "cb";
        rev = "main"; # Replace with the desired commit or tag
        sha256 = "sha256-OsHIacgorYnB/dPbzl1b6rYUzQdhTtsJYLsFLJxregk=";
      };

      goPackagePath = "github.com/niedzielski/cb";

      buildInputs = with super; [
        go
      ];
    };
  })
]
