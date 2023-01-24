{ pkgs, src, doCheck ? true,
  soralog, yaml-cpp, tsl-hat-trie, boost-di, sqlite3, sqlite-modern-cpp, protobuf, microsoft_gsl_2
}:
with pkgs;
let
  # use clang 12 as compiler
  stdenv = pkgs.llvmPackages_14.stdenv;
  build_tests-cmakeFlag = "-DTESTING=" + (if doCheck then "ON" else "OFF");
  build_examples-cmakeFlag = "-DEXAMPLES=" + (if doCheck then "ON" else "OFF");
in
stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "libp2p";
  version = "0.1.8";

  checkInputs = [ gtest ];
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost172 openssl_1_1 c-ares fmt pkg-config zlib ]
                      ++ [ soralog yaml-cpp tsl-hat-trie boost-di sqlite-modern-cpp protobuf sqlite3 microsoft_gsl_2 ];

  outputs = [ "out" "dev" ];
  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" build_tests-cmakeFlag build_examples-cmakeFlag ];
}
