use std::path::Path;

const GITHUB_LOCKED_PACKAGE: &str = std::include_str!("exprs/github_locked_package.nix");

/// Returns an expression that will evaluate to the `package` specified by the given flake lock file
///
/// The references are assumed to be github references
pub fn package_from_flake(lockfile: impl AsRef<Path>, package: &str) -> String {
    let path = lockfile.as_ref().display();

    format!(
        r##"
let
    package = ({GITHUB_LOCKED_PACKAGE}) {{ lockPath = {path}; package = {package:?}; }};
in
    import package {{}}
"##
    )
}

/// Returns an expression that will evaluate to the nixpkgs set specified by the given flake lock file
///
/// `nixpkgs_name` will default to "nixpkgs", but should match the flake input name that is to be used
pub fn nixpkgs_from_flake(lockfile: impl AsRef<Path>, nixpkgs_name: Option<&str>) -> String {
    package_from_flake(lockfile, nixpkgs_name.unwrap_or("nixpkgs"))
}

/// Run the given `expr` in a context where `lets` are expanded in order.
///
/// # Example
/// ```rust
/// # use nix_build::exprs::nix_let;
/// let expr = nix_let(&["foo = 1", "bar = 2"], "foo + bar");
///
/// assert_eq!(expr,
/// format!("let foo = 1;
/// bar = 2;
///  in foo + bar"))
/// ```
pub fn nix_let(lets: &[&str], expr: &str) -> String {
    let declarations = lets.join(";\n");

    format!("let {declarations};\n in {expr}")
}
