# nix-build

A build dependency for running the `nix` package manager, inspired by `cmake`.

``` toml
# Cargo.toml
[build-dependencies]
nix-build = "0.1"
```

The `nix` executable is assumed to be `nix` unless the `NIX` environment variable is set.

# License

This project is licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
   https://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or
   https://opensource.org/licenses/MIT)

at your option.
