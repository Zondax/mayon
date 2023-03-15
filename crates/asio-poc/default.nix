{ pkgs, cxxbridge-out, cxxbridge ? ../../nix/crates/cxxbridge.nix }:
let
  cxxbridge-drv = pkgs.callPackage cxxbridge {
    inherit crate;
    src = cxxbridge-out;
  };
  asio = pkgs.callPackage (/. + pkgs.path + /pkgs/development/libraries/asio/generic.nix) {
    version = "1.27.0";
    sha256 = "918da9e9eca6dd10431432c73ec7ed1347aeda31a64f38917eb2a4501c8195e1";
  };
  crate = pkgs.stdenv.mkDerivation {
    pname = "cpp-asio-poc";
    version = "0.1.0";
    src = ./.;

    cmakeFlags = [ "-DHUNTER_ENABLED=OFF" "-DCXXBRIDGE_OUT=${cxxbridge-drv}" ];

    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
    buildInputs = [ asio ];
  };
in crate
