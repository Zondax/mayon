let
  tree =
    { pkgs, path, maxDepth ? null }:
    let
      root = builtins.readDir path;
      only-dirs = if maxDepth == 0 then {} else
        pkgs.lib.attrsets.filterAttrs
        (_: value: value == "directory") root;
      recMaxDepth = if maxDepth == null then null else maxDepth - 1;
      dirs = pkgs.lib.attrsets.mapAttrs
        (name: _: tree { inherit pkgs; path = path + "/${name}"; maxDepth = recMaxDepth; })
        only-dirs;

      files-and-links = pkgs.lib.attrsets.filterAttrs
        (_: v: v == "regular" || v == "symlink") root;
      files = pkgs.lib.attrsets.mapAttrs
        (name: _: path + "/${name}") files-and-links;
    in
      root // dirs // files;
in
tree
