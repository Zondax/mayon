{
  description = "Our C++ Polkadot Host modules";

  inputs = {
    # Nix Utils
    nixpkgs.url = "nixpkgs/nixos-22.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { self', inputs', pkgs, ... }:
        let
          rust = inputs'.fenix.packages.stable.toolchain;
          crane = (inputs.crane.mkLib pkgs).overrideToolchain rust;

          deps = pkgs.callPackage ./nix/deps.nix { };
          tools = pkgs.callPackage ./nix/tools.nix { inherit crane; };
          crates = pkgs.callPackage ./nix/crates.nix {
            inherit tools crane;
            src = ./crates;
          };

          commonArgs = {
            src = ./.;

            nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
            buildInputs = [ deps.cpp-libp2p ];
          };
          cargoArtifacts = crane.buildDepsOnly commonArgs;
          workspace = crane.buildPackage (commonArgs // {
            src = ./.;
            pname = "mayon";

            inherit cargoArtifacts;
          });
        in {
          devShells.default = pkgs.mkShell {
            inputsFrom = [ workspace ];
            packages = [ pkgs.just rust tools.ffizer pkgs.niv ];
          };

          packages.mayon = workspace;
          packages.default = self'.packages.mayon;

          packages.crates = crates;
        };
    };

}
