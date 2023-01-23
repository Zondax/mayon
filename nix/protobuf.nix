{ pkgs, src, doCheck ? true }:
with pkgs;
let
  build_tests-cmakeFlag = "-Dprotobuf_BUILD_TESTS="
    + (if doCheck then "ON" else "OFF");
in stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "protobuf";
  version = "3.11.2";

  checkInputs = [ gtest ];
  nativeBuildInputs = [ cmake zlib pkg-config ];

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" build_tests-cmakeFlag ];

  # https://github.com/NixOS/nixpkgs/blob/cdead16a444a3e5de7bc9b0af8e198b11bb01804/pkgs/development/libraries/protobuf/generic-v3-cmake.nix#L34-58
  # re-create submodule logic
  postPatch = ''
    rm -rf gmock
    cp -r ${gtest.src}/googlemock third_party/gmock
    cp -r ${gtest.src}/googletest third_party/
    chmod -R a+w third_party/
    ln -s ../googletest third_party/gmock/gtest
    ln -s ../gmock third_party/googletest/googlemock
    ln -s $(pwd)/third_party/googletest third_party/googletest/googletest
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  # fix protobuf-targets.cmake installation paths, and allow for CMAKE_INSTALL_LIBDIR to be absolute
  # https://github.com/protocolbuffers/protobuf/pull/10090
  ## adapted for cpp-pm/protobuf
  patches = lib.optionals (lib.versionOlder version "3.22")
    ./protobuf-target.cmake-install.patch;
}
