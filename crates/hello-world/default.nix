{ pkgs
, cxxbridge-out
, cpp-libp2p ? (import ../../nix/deps.nix { inherit pkgs; }).cpp-libp2p
}:
let
  cxxbridge = import ../cxxbridge.nix { inherit pkgs crate;
                                        src = cxxbridge-out; };
  crate =
    pkgs.stdenv.mkDerivation {
      pname = "hello-world";
      version = "0.1.0";
      src = ./.;

      cmakeFlags = [ "-DHUNTER_ENABLED=OFF" "-DCXXBRIDGE_OUT=${cxxbridge}" ];

      nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
      buildInputs = [ cpp-libp2p ];
    };
in
crate
