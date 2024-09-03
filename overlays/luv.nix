# luv.nix
{ lib, stdenv, fetchFromGitHub, cmake, libuv, lua }:

stdenv.mkDerivation rec {
  pname = "luv";
  version = "1.43.0-0";

  src = fetchFromGitHub {
    owner = "luvit";
    repo = "luv";
    rev = "1.43.0-0";
    sha256 = "0k9b7p4pvzv14bgnnqay9ld12a53lxq5gjvcj9kxxzd7y7jlfvf5";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv lua ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLUA_BUILD_TYPE=System"
    "-DBUILD_SHARED_LIBS=ON"
  ];
}
