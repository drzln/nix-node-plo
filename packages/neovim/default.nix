{ stdenv
, fetchFromGitHub
, cmake
, ninja
, gettext
, lib
, autoPatchelfHook
, libuv
, msgpack
, tree-sitter
, libiconv
, pkg-config
, fixupDarwin ? null
, pkgs
, darwin ? null
}:

let
  libvterm = pkgs.callPackage ./deps/libvterm.nix { inherit pkgs; };
  deps = pkgs.callPackage ./deps { inherit pkgs; };
in

stdenv.mkDerivation {
  pname = "neovim";
  version = "0.10.1-dev";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "7e194f0d0c33a0a1b7ccfaf2baafdacf7f22fbb5";
    sha256 =
      if stdenv.isLinux then
        "dCwN7Z4t+pmGuH90Dff5h1qIm2Rh917cZX3GF/W5GYk="  # Linux sha256
      else if stdenv.isDarwin then
        "sha256-OsHIacgorYnB/dPbzl1b6rYUzQdhTtsJYLsFLJxregk="  # Darwin sha256
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
    libvterm
    pkgs.luajitPackages.lpeg
    pkgs.luajitPackages.mpack
    libiconv
    tree-sitter
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  preConfigure = ''
    export PATH=${pkgs.luajitPackages.libluv}/bin:${pkgs.libuv}/bin:$PATH
    export CMAKE_PREFIX_PATH=${pkgs.libuv}:${libvterm}:${pkgs.msgpack}:${pkgs.tree-sitter}:${pkgs.unibilium}:${pkgs.luajitPackages.lpeg}
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    export CMAKE_OSX_SYSROOT=$(xcrun --sdk --show-sdk-path)
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DDEPS_PREFIX=${deps}"
  ];

  postInstall = ''
    ${if stdenv.isLinux then
    ''
      addAutoPatchelfSearchPath ${pkgs.libuv}/lib
      addAutoPatchelfSearchPath ${pkgs.libvterm}/lib
      addAutoPatchelfSearchPath ${pkgs.msgpack}/lib
    ''
    else if stdenv.isDarwin then
      "install_name_tool -change /old/path/libfoo.dylib ${deps}/lib/libfoo.dylib $out/bin/nvim"
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

