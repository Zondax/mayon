{ pkgs
, cxxbridge-out
, cxxbridge ? ../../nix/crates/cxxbridge.nix
, cpp-libp2p ? (import ../../nix/deps.nix { inherit pkgs; }).cpp-libp2p
}:
let
  cxxbridge-drv = pkgs.callPackage cxxbridge { inherit crate; src = cxxbridge-out; };
  crate =
    pkgs.stdenv.mkDerivation {
      pname = "hello-world";
      version = "0.1.0";
      src = ./.;

      cmakeFlags = [ "-DHUNTER_ENABLED=OFF" "-DCXXBRIDGE_OUT=${cxxbridge-drv}" ];

      nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
      buildInputs = [ cpp-libp2p ];
    };
in
crate
