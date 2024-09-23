{ stdenv, fetchFromGitHub, cmake, ninja, gettext, lib, autoPatchelfHook, deps, libuv, msgpack, tree-sitter, pkg-config, fixupDarwin ? null, pkgs }:

stdenv.mkDerivation {
  pname = "neovim";
  version = "0.10.1-dev";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "b1ae775de618e3e87954a88d533ec17bbef41cdf";
    sha256 =
      if stdenv.isLinux then
        "dCwN7Z4t+pmGuH90Dff5h1qIm2Rh917cZX3GF/W5GYk="  # Linux sha256
      else if stdenv.isDarwin then
        "vnyHIanZrm9rlvl2tBXxWLsZiwUx9N4dkJ7ohXcinYg="  # Darwin sha256
      else
        throw "Unsupported platform";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook
  ++ lib.optional (stdenv.isDarwin && fixupDarwin != null) fixupDarwin;

  buildInputs = [
    gettext
    deps
    libuv
    msgpack
    pkgs.luajitPackages.libluv
    pkgs.luajit
    pkgs.unibilium
    pkgs.libtermkey
    pkgs.libvterm
    tree-sitter
  ];

  preConfigure = ''
    export PATH=${deps}/luajit/bin:${deps}/luv/bin:${deps}/libuv/bin:${deps}/libvterm/bin:${deps}/lpeg/bin:${deps}/msgpack/bin:${deps}/treesitter/bin:${deps}/unibilium/bin:$PATH
    export CMAKE_PREFIX_PATH=${deps}
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DDEPS_PREFIX=${deps}"
  ];

  postInstall = ''
    ${if stdenv.isLinux then
      "addAutoPatchelfSearchPath ${deps}/luajit/lib/"
    else if stdenv.isDarwin then
      "install_name_tool -change /old/path/libfoo.dylib ${deps}/lib/libfoo.dylib $out/bin/neovim"
    else
      ""}
  '';

  meta = {
    homepage = "https://neovim.io";
    description = "Neovim built with Nix";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ "joakimpaulsson" ];
  };
}

