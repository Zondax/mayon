{ pkgs, src, doCheck ? true,
  soralog, yaml-cpp, tsl-hat-trie, boost-di, sqlite3, sqlite-modern-cpp, protobuf, microsoft_gsl_2
}:
with pkgs;
let
  # use clang 12 as compiler
  stdenv = pkgs.llvmPackages_14.stdenv;
in
stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "libp2p";
  version = "0.1.8";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ gtest boost172 openssl_1_1 c-ares fmt pkg-config zlib ]
                      ++ [ soralog yaml-cpp tsl-hat-trie boost-di sqlite-modern-cpp protobuf sqlite3 microsoft_gsl_2 ];

  outputs = [ "out" "dev" ];
  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" ];
}
