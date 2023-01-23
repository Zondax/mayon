{
  description = "Our C++ Polkadot Host modules";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    ffizer-src = {
      url = "github:ffizer/ffizer";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, fenix, crane, ffizer-src, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        rust = fenix.packages.${system}.stable.toolchain;
        ffizer = import ./nix/ffizer.nix {
          inherit pkgs ffizer-src;
          crane = crane.lib.${system}.overrideToolchain rust;
        };
      in {
        devShells.default =
          pkgs.mkShell { buildInputs = [ pkgs.just ffizer rust pkgs.cmake ]; };
      });
}
