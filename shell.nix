(import (let lock = buildints.fromJSON (buildins.readFile ./flake.lock);
in fetchTarball {
  url =
    "https://github.com/edolstra/flake-compat/archive/${lock.node.flake-compat.locked.rev}.tar.gz";
  sha256 = lock.nodes.flake-compat.locked.narHash;
}) { src = ./.; }).shellNix
