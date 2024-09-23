{ stdenv, fetchFromGitHub, cmake, ninja, callPackage, gettext, lib, autoPatchelfHook, deps, fixupDarwin ? null }:

let
  luaPatch = pkgs.writeText "lua-macos-patch.patch" ''
    --- a/src/Makefile
    +++ b/src/Makefile
    @@ -52,7 +52,7 @@
      # -Wl,-E        export dynamic symbols for dynamic linking (ld option)
      # -ldl          the dynamic linking library

    -LDFLAGS= -Wl,-E
    +LDFLAGS= -flat_namespace -undefined dynamic_lookup

     MYCFLAGS= -DLUA_USE_LINUX
     MYLDFLAGS=
  '';
in
stdenv.mkDerivation {
  pname = "lua";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "lua";
    repo = "lua";
    rev = "98194db4295726069137d13b8d24fca8cbf892b6";
    sha256 = "sha256-vnyHIanZrm9rlvl2tBXxWLsZiwUx9N4dkJ7ohXcinYg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook ++ lib.optional (stdenv.isDarwin && fixupDarwin != null) fixupDarwin;

  buildInputs = [ gettext deps ];

  # Apply patch only on Darwin (macOS)
  patches = lib.optional stdenv.isDarwin luaPatch;

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
      "install_name_tool -change /old/path/libfoo.dylib ${deps}/lib/libfoo.dylib $out/bin/lua"
    else
      ""}
  '';

  meta = {
    homepage = "https://www.lua.org";
    description = "Lua programming language built with Nix";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ "luis" ];
  };
}

