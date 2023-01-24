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
  };

  outputs = inputs@{ nixpkgs, flake-utils, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        rust = fenix.packages.${system}.stable.toolchain;
        crane = inputs.crane.lib.${system}.overrideToolchain rust;

        deps = pkgs.callPackage ./nix/deps.nix { };
        tools = pkgs.callPackage ./nix/tools.nix { inherit crane; };

        workspace = pkgs.callPackage crane.buildPackage {
          stdenv = pkgs.llvmPackages_14.stdenv;

          src = ./.;
          nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
          buildInputs = [ deps.cpp-libp2p ];
        };
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [ workspace deps.cpp-libp2p ];
          packages = [ pkgs.just rust tools.ffizer pkgs.niv ];
        };
      });
}
