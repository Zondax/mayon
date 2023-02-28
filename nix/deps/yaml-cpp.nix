{ pkgs, src, doCheck ? false }:
with pkgs;
let
  build_tests-cmakeFlag = "-DYAML_CPP_BUILD_TESTS="
    + (if doCheck then "ON" else "OFF");
in stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "yaml-cpp";
  version = "v0.6.2-0f9a586-p1";

  checkInputs = [ gtest ];
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ build_tests-cmakeFlag ];
}
