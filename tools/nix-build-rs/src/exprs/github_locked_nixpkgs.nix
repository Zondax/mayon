{ rev, sha256 }:
let
  fetched = fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  };
in fetched
