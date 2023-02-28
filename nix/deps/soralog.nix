{ pkgs, src, doCheck ? true, yaml-cpp }:
let
  build_tests-cmakeFlag = "-DTESTING=" + (if doCheck then "ON" else "OFF");
  build_examples-cmakeFlag = "-DEXAMPLES=" + (if doCheck then "ON" else "OFF");
in with pkgs;
stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "soralog";
  version = "0.1.3";

  checkInputs = [ gtest ];
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fmt yaml-cpp ];

  cmakeFlags =
    [ "-DHUNTER_ENABLED=OFF" build_tests-cmakeFlag build_examples-cmakeFlag ];
}
