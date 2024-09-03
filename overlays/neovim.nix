# neovim.nix
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "neovim";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/neovim/neovim/releases/download/v${version}/nvim-linux64.tar.gz";
    sha256 = "sha256-value-here"; # Replace with actual SHA256 hash
  };

  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin --strip-components=1
  '';
}
