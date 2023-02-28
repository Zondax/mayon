{ pkgs }:
let
  sources = import ./sources.nix { inherit pkgs; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    yaml-cpp = callPackage ./deps/yaml-cpp.nix { src = sources.yaml-cpp; };
    soralog = callPackage ./deps/soralog.nix { src = sources.soralog; };
    tsl-hat-trie =
      callPackage ./deps/tsl-hat-trie.nix { src = sources.tsl-hat-trie; };
    boost-di = callPackage ./deps/boost-di.nix { src = sources.boost-di; };
    microsoft_gsl_2 =
      callPackage ./deps/microsoft_gsl.nix { src = sources.microsoft_gsl_2; };
    sqlite3 = callPackage ./deps/sqlite3.nix { src = sources.sqlite3; };
    sqlite-modern-cpp = callPackage ./deps/sqlite-modern-cpp.nix {
      src = sources.libp2p-sqlite-modern-cpp;
    };
    protobuf = callPackage ./deps/protobuf.nix { src = sources.protobuf; };
    cpp-libp2p = callPackage ./deps/cpp-libp2p.nix { src = sources.cpp-libp2p; };
  };
in packages
