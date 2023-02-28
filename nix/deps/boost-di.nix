{ pkgs, src }:
with pkgs;
stdenv.mkDerivation rec {
  inherit src;

  pname = "boost-di";
  version = "v1.1.0";
  doCheck = false;

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DBOOST_DI_OPT_BUILD_TESTS=OFF" "-DBOOST_DI_OPT_BUILD_EXAMPLES=OFF" ];
}
