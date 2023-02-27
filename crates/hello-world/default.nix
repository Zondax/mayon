{ pkgs
, cxxbridge-out
, cpp-libp2p ? (import ../../nix/deps.nix { inherit pkgs; }).cpp-libp2p
}:
let
  pname = "hello-world";
  src = ./.;
  cxxbridge = import ../cxxbridge.nix { inherit pkgs;
                                        src = cxxbridge-out;
                                        crate-src = src;
                                        crate-name = pname; };
in
pkgs.stdenv.mkDerivation {
  inherit pname src;
  version = "0.1.0";

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF" "-DCXXBRIDGE_OUT=${cxxbridge}" ];

  nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake cpp-libp2p ];
  buildInputs = [ cpp-libp2p ];
}
