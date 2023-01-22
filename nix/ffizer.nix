{ sources ? import ./sources.nix
, pkgs ? import sources.nixpkgs {}
, fenix ? import sources.fenix {}
, naersk ? pkgs.callPackage sources.naersk {
    cargo = fenix.stable.toolchain;
    rustc = fenix.stable.toolchain;
  }
}:
naersk.buildPackage {
  src = sources.ffizer;

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl perl ];
}
