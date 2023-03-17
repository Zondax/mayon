{ pkgs, src, crane }:
crane.buildPackage {
  inherit src;

  nativeBuildInputs = with pkgs; [ pkg-config perl ];
  buildInputs = with pkgs; [ openssl ];
}
