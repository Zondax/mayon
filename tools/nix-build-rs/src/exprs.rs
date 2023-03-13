use std::path::Path;

const GITHUB_LOCKED_NIXPKGS: &str = std::include_str!("exprs/github_locked_nixpkgs.nix");

/// Returns an expression that will evaluate to the nixpkgs set specified by the given flake lock file
///
/// `nixpkgs_name` will default to "nixpkgs", but should match the flake input name that is to be used
pub fn nixpkgs_from_flake(lockfile: impl AsRef<Path>, nixpkgs_name: Option<&str>) -> String {
    let path = lockfile.as_ref().display();
    let nixpkgs = nixpkgs_name.unwrap_or("nixpkgs");

    format!(
        r##"
let
    lock = builtins.fromJSON (builtins.readFile {path});
    nixpkgs_node = lock.nodes.{nixpkgs}.locked;
    nixpkgs = ({GITHUB_LOCKED_NIXPKGS}) {{ rev = nixpkgs_node.rev; sha256 = nixpkgs_node.narHash; }};
in
    import nixpkgs {{}}
"##
    )
}
