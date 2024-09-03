{ lib, stdenv, fetchFromGitHub, cmake, ninja, libtool, pkgconfig, gettext, lua, msgpack, libuv, tree-sitter, unzip, callPackage }:

# Import the luv derivation from the file
let
  luv = callPackage ./luv.nix { inherit lua libuv cmake; };
in
stdenv.mkDerivation rec {
  pname = "neovim_raw";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "v${version}";
    sha256 = "your-correct-sha256-hash";  # Replace this with the actual sha256 hash for v0.8.0
  };

  nativeBuildInputs = [ cmake ninja libtool pkgconfig gettext unzip ];

  buildInputs = [ lua luv msgpack libuv tree-sitter ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DLIBLUV_INCLUDE_DIR=${luv.dev}/include"
    "-DLIBLUV_LIBRARY=${luv}/lib/libluv.so"
  ];
}
