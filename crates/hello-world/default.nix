{ pkgs, crane, cxxbridge ? ../../nix/crates/cxxbridge-gen.nix
, cpp-libp2p ? (import ../../nix/deps.nix { inherit pkgs; }).cpp-libp2p }:
let
  cxxbridge-out = pkgs.callPackage cxxbridge ({ inherit crate crane; });
  crate = pkgs.stdenv.mkDerivation {
    pname = "hello-world";
    version = "0.1.0";
    src = ./.;

    cmakeFlags = [ "-DHUNTER_ENABLED=OFF" "-DCXXBRIDGE_OUT=${cxxbridge-out}" ];

    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
    buildInputs = [ cpp-libp2p ];
  };
in crate
