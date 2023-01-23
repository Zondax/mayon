{ pkgs, src, sqlite3 }:
with pkgs;
stdenv.mkDerivation rec {
  inherit src;

  pname = "sqlite-modern-cpp";
  version = "v3.2.1";

  nativeBuildInputs = [ sqlite3 cmake pkg-config ];

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" ];
}
