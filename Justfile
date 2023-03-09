alias default := _help
# Show this menu
@_help:
    just --list --unsorted

in_nix_shell := env_var_or_default("IN_NIX_SHELL", "false")
root_dir := justfile_directory()
_run-in-nix-shell cmd *args:
    #!/usr/bin/env -S sh -eu
    if [ "{{ in_nix_shell }}" = "false" ]; then
        nix-shell "shell.nix" --run "just \"{{ root_dir }}/{{ cmd }}\" {{ args }}"
    else
        just "{{ root_dir }}/{{ cmd }}" {{ args }}
    fi

# Create a new crate library
new destination: (_run-in-nix-shell "_new" destination)
_new destination:
    ffizer apply -s .crate-ffizer -d crates/{{destination}}

# Clean up project files
clean:
    just cargo clean

alias c := cargo
# Invoke cargo
cargo *args: (_run-in-nix-shell "_cargo" args)
_cargo *args:
    cargo {{args}}

alias b := build
# Build project
build *args:
    just cargo build {{args}}

# Create docker image (used to run tests)
docker name="mayon":
    just cargo clean
    docker build -t {{name}} .
