{ pkgs, src, crane }:
crane.buildPackage {
  inherit src;

  # package tests require access to internet
  doCheck = false;

  nativeBuildInputs = with pkgs; [ pkg-config perl ];
  buildInputs = with pkgs; [ openssl ];
}
