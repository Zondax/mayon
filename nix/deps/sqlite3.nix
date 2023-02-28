{ pkgs, src }:
with pkgs;
stdenv.mkDerivation rec {
  inherit src;

  pname = "sqlite3";
  version = "v3.30.1";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" ];
}
