{ pkgs, crate, crane, cxxbridge-cmd ?
  (pkgs.callPackage ../tools.nix { inherit crane; }).cxxbridge-cmd }:
let
  buildCommand = ''
    "$cxxbridge"/bin/cxxbridge --version

    CXX_SOURCES=$(grep --include=\*.rs -Rl '\#\[cxx::bridge\]' "$src")

    OUT_SOURCES="$out"/sources/"$crate_name"
    OUT_HEADERS="$out"/include/"$crate_name"

    mkdir -p $OUT_SOURCES $OUT_INCLUDES "$out"/include/rust "$out"/crate

    for SRC in $CXX_SOURCES; do
        FILENAME=$(echo "$SRC" | cut -d'/' -f5-)
        echo "$FILENAME" $(dirname $FILENAME)
        mkdir -p $OUT_SOURCES/$(dirname "$FILENAME") $OUT_HEADERS/$(dirname "$FILENAME")

        "$cxxbridge"/bin/cxxbridge "$SRC" -o $OUT_SOURCES/"$FILENAME".cc
        "$cxxbridge"/bin/cxxbridge "$SRC" --header -o $OUT_HEADERS/"$FILENAME".h
        ln -s ./$(basename "$FILENAME".h) $OUT_HEADERS/"$FILENAME"
    done

    "$cxxbridge"/bin/cxxbridge --header -o "$out"/include/rust/cxx.h
    ln -s $src "$out"/crate/$crate_name
  '';
in pkgs.stdenvNoCC.mkDerivation {
  name = "${crate.pname}-${crate.version}-cxxbridge";
  src = crate.src;

  crate_name = crate.pname;
  cxxbridge = cxxbridge-cmd;
  inherit buildCommand;
}
