{ stdenv, fetchFromGitHub, cmake, ninja, callPackage, gettext, lib, fixupDarwin, autoPatchelfHook, deps }:

stdenv.mkDerivation {
  pname = "neovim";
  version = "0.10.1-dev";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "b1ae775de618e3e87954a88d533ec17bbef41cdf";
    sha256 = "dCwN7Z4t+pmGuH90Dff5h1qIm2Rh917cZX3GF/W5GYk="; # Ensure this hash is correct
  };

  nativeBuildInputs = [
    cmake
    ninja
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook ++ lib.optional stdenv.isDarwin fixupDarwin;

  buildInputs = [ gettext deps ];

  # Set environment variables appropriately
  preConfigure = ''
    export PATH=${deps}/luajit/bin:${deps}/luv/bin:${deps}/libuv/bin:${deps}/libvterm/bin:${deps}/lpeg/bin:${deps}/msgpack/bin:${deps}/treesitter/bin:${deps}/unibilium/bin:$PATH
    export CMAKE_PREFIX_PATH=${deps}
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DDEPS_PREFIX=${deps}"
  ];

  # Apply the correct fixup hook based on the platform
  postInstall = ''    ${ if stdenv.isLinux then
      "addAutoPatchelfSearchPath ${deps}/luajit/lib/"
    else if stdenv.isDarwin then
      "install_name_tool -change /old/path/libfoo.dylib ${deps}/lib/libfoo.dylib $out/bin/neovim" # Replace with actual paths if needed
    else
      ""
    }
  '';

  meta = {
    homepage = "https://neovim.io";
    description = "Neovim built with Nix";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ "joakimpaulsson" ];
  };
}

