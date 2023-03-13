{ pkgs, cxxbridge-out, cxxbridge ? ../../nix/crates/cxxbridge.nix }:
let
  cxxbridge-drv = pkgs.callPackage cxxbridge {
    inherit crate;
    src = cxxbridge-out;
  };
  crate = pkgs.stdenv.mkDerivation {
    pname = "cpp-asio-poc";
    version = "0.1.0";
    src = ./.;

    cmakeFlags = [ "-DHUNTER_ENABLED=OFF" "-DCXXBRIDGE_OUT=${cxxbridge-drv}" ];

    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
    buildInputs = [ pkgs.asio ];
  };
in crate
