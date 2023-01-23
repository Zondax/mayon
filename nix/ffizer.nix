{ pkgs, ffizer-src, crane }:
crane.buildPackage {
  src = ffizer-src;

  # package tests require access to internet
  doCheck = false;

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl perl ];
}
