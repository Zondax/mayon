{ pkgs, src, doCheck ? true }:
with pkgs;
stdenv.mkDerivation rec {
  inherit src doCheck;

  pname = "soralog";
  version = "0.1.3";

  checkInputs = [ gtest ];
  nativeBuildInputs = [ cmake fmt yaml-cpp ];

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" ];
}
