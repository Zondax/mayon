{
  description = "Our C++ Polkadot Host modules";

  inputs = {
    # Nix Utils
    nixpkgs.url = "nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Development dependencies
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

  outputs = inputs@{ nixpkgs, flake-utils, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays
          [ (import ./nix/overlay.nix) ];
        rust = fenix.packages.${system}.stable.toolchain;
        crane = inputs.crane.lib.${system}.overrideToolchain rust;
        ffizer = import ./nix/ffizer.nix {
          inherit pkgs crane;
          src = inputs.ffizer-src;
        };
        workspace = pkgs.callPackage crane.buildPackage {
          stdenv = pkgs.llvmPackages_14.stdenv;

          src = ./.;
          nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
          buildInputs = [ pkgs.cpp-libp2p ];
        };
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [ workspace pkgs.cpp-libp2p ];
          packages =
            [ pkgs.just ffizer rust ];
        };
      });
}
