inputs@{ pkgs, src, ... }:
let
  crates = import ./tree.nix { inherit pkgs; path = src; maxDepth = 1; };
  cxxbridge = ./crates/cxxbridge.nix;
  only-dirs = pkgs.lib.attrsets.filterAttrs
    (_: v: builtins.isAttrs v) crates;
  manifests = pkgs.lib.attrsets.mapAttrs
    (_: v: v."default.nix") only-dirs;
  packages = pkgs.lib.attrsets.mapAttrs
    (name: v:
      let
        has_overrides = pkgs.lib.attrsets.hasAttrByPath [ name ] inputs;
        overrides = if has_overrides then pkgs.lib.attrsets.getAttrFromPath [ name ] inputs else { };
      in pkgs.callPackage v ({ inherit cxxbridge; } // overrides)) manifests;
  packagesList = pkgs.lib.attrsets.attrValues packages;

  # taken from mkShell implementation
  mergeInputs = name:
    (pkgs.lib.subtractLists packagesList
      (pkgs.lib.flatten (pkgs.lib.catAttrs name packagesList)));

in
packages // { meta = {
                inherit packagesList;
                buildInputs = mergeInputs "buildInputs";
                nativeBuildInputs = mergeInputs "nativeBuildInputs";
                propagatedBuildInputs = mergeInputs "propagatedBuildInputs";
                propagatedNativeBuildInputs = mergeInputs "propagatedNativeBuildInputs";
              }; }
