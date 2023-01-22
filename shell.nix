{ sources ? import ./nix/sources.nix {}
, pkgs ? import sources.nixpkgs {}
, ffizer ? import ./nix/ffizer.nix { inherit sources; }
}:

let
  fenix = import sources.fenix {};

  deps = {
    tools = [
      pkgs.just
      ffizer
      fenix.stable.toolchain
    ];

    build = [
      pkgs.cmake
    ];
  };
in

pkgs.mkShell {
  buildInputs = builtins.concatLists [
    deps.tools
    deps.build
  ];
}
