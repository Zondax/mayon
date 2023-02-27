{ pkgs
, cxxbridge-out
, cpp-libp2p ? (import ../../nix/deps.nix { inherit pkgs; }).cpp-libp2p
}:
  pname = "hello-world";
pkgs.stdenv.mkDerivation {
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake cpp-libp2p ];
  buildInputs = [ cpp-libp2p ];
}
