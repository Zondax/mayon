{ pkgs, crane }:
let
  sources = import ./sources.nix { inherit pkgs; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    ffizer = callPackage ./tools/ffizer.nix {
      inherit crane;
      src = sources.ffizer;
    };
  };
in packages
