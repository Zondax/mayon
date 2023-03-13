{ pkgs, src, doCheck ? false }:
with pkgs;
let tests-cmakeFlag = "-DGSL_TEST=" + (if doCheck then "ON" else "OFF");
in stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "microsoft_gsl";
  version = "2.0.0";

  checkInputs = [ gtest git ];
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" tests-cmakeFlag ];
}
