{ pkgs, crane }:
let
  sources = import ./sources.nix { inherit pkgs; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    ffizer = callPackage ./tools/ffizer.nix {
      inherit crane;
      src = sources.ffizer;
    };
    cxxbridge-cmd = callPackage ./tools/cxxbridge-cmd.nix {
      inherit crane;
      src = pkgs.fetchCrate {
        crateName = "cxxbridge-cmd";
        version = "1.0.92";
        sha256 = "sha256-+iyfWrkltOrMSFfrlZuY79xQqns5F4bnAZPhCoKMsCY=";
      };
    };
  };
in packages
