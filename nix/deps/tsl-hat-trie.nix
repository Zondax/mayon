{ pkgs, src }:
with pkgs;
stdenv.mkDerivation rec {
  inherit src;

  pname = "tsl_hat_trie";
  version = "1.0.0";

  nativeBuildInputs = [ cmake ];
}
