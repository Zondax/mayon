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
clean: (_run-in-nix-shell "_clean")
_clean:
    cargo clean


alias b := build
# Build project
build *args: (_run-in-nix-shell "_build" args)
_build *args:
    cargo build {{args}}
