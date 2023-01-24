{ pkgs }:
let
  sources = import ./sources.nix { inherit pkgs; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    yaml-cpp = callPackage ./yaml-cpp.nix { src = sources.yaml-cpp; };
    soralog = callPackage ./soralog.nix { src = sources.soralog; };
    tsl-hat-trie =
      callPackage ./tsl-hat-trie.nix { src = sources.tsl-hat-trie; };
    boost-di = callPackage ./boost-di.nix { src = sources.boost-di; };
    microsoft_gsl_2 =
      callPackage ./microsoft_gsl.nix { src = sources.microsoft_gsl_2; };
    sqlite3 = callPackage ./sqlite3.nix { src = sources.sqlite3; };
    sqlite-modern-cpp = callPackage ./sqlite-modern-cpp.nix {
      src = sources.libp2p-sqlite-modern-cpp;
    };
    protobuf = callPackage ./protobuf.nix { src = sources.protobuf; };
    cpp-libp2p = callPackage ./cpp-libp2p.nix { src = sources.cpp-libp2p; };
  };
in packages
