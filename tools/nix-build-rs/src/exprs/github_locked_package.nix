{ lockPath, package }:
let
  # from
  # https://github.com/NixOS/nixpkgs/blob/d100ba4b79a3014963acd8e7e4e41c3169ca1dcb/lib/attrsets.nix#L30
  attrByPath = attrPath: default: set:
    let attr = builtins.head attrPath;
    in if attrPath == [ ] then
      set
    else if set ? ${attr} then
      attrByPath (builtins.tail attrPath) default set.${attr}
    else
      default;

  lock = builtins.fromJSON (builtins.readFile lockPath);
  node = attrByPath [ package "locked" ] { } lock.nodes;
  fetched = fetchTarball {
    sha256 = node.narHash;
    url =
      "https://github.com/${node.owner}/${node.repo}/archive/${node.rev}.tag.gz";
  };
in fetched
