{ pkgs
, stdenv ? pkgs.stdenv
, cpp-libp2p ? (import ../../nix/deps.nix { inherit pkgs; }).cpp-libp2p
}:
stdenv.mkDerivation {
  pname = "hello-world";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
  buildInputs = [ cpp-libp2p ];
}
