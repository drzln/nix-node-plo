# neovim.nix
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "neovim";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/neovim/neovim/releases/download/v${version}/nvim-linux64.tar.gz";
    sha256 = "0ca97ld7flcx7sjbwdwcrm8pbsxdb5dspf9p51rna7zhkis7bl59";
  };

  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin --strip-components=1
  '';
}
