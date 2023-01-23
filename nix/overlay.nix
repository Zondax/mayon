final: prev:
let
  sources = import ./sources.nix { pkgs = prev; };
  doCheck = false;
in {
  soralog = final.callPackage ./soralog.nix { src = sources.soralog; };
  yaml-cpp = final.callPackage ./yaml-cpp.nix {
    inherit doCheck;
    src = sources.yaml-cpp;
  };
  tsl-hat-trie =
    final.callPackage ./tsl-hat-trie.nix { src = sources.tsl-hat-trie; };
  boost-di = final.callPackage ./boost-di.nix { src = sources.boost-di; };
  microsoft_gsl_2 = final.callPackage ./microsoft_gsl.nix { inherit doCheck; src = sources.microsoft_gsl_2; };
  sqlite3 = final.callPackage ./sqlite3.nix { src = sources.sqlite3; };
  sqlite-modern-cpp = final.callPackage ./sqlite-modern-cpp.nix {
    src = sources.libp2p-sqlite-modern-cpp;
  };
  cpp-libp2p =
    let protobuf = final.callPackage ./protobuf.nix { src = sources.protobuf; };
    in final.callPackage ./cpp-libp2p.nix {
      inherit protobuf doCheck;
      src = sources.cpp-libp2p;
    };
}
