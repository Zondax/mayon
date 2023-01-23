{ sources ? import ./sources.nix
, pkgs ? import sources.nixpkgs {}
, fenix ? import sources.fenix {}
, crane ? with (import sources.crane {}); overrideToolchain fenix.stable.toolchain
}:
crane.buildPackage {
  src = sources.ffizer;

  # package tests require access to internet
  doCheck = false;

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl perl ];
}
