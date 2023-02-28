{ pkgs, src, sqlite3 }:
with pkgs;
stdenv.mkDerivation rec {
  inherit src;

  pname = "sqlite-modern-cpp";
  version = "v3.2.1";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ sqlite3 ];

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" ];
}
