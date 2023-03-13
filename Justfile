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

empty_closure := "AQAAAAAAAAANAAAAAAAAAG5peC1hcmNoaXZlLTEAAAABAAAAAAAAACgAAAAAAAAABAAAAAAAAAB0eXBlAAAAAAcAAAAAAAAAcmVndWxhcgAIAAAAAAAAAGNvbnRlbnRz0AAAAAAAAABEZXJpdmUoWygib3V0IiwiL25peC9zdG9yZS96aGhuZDlnamQ0bHlzNzdweTJtOXc2OXZ5MWJtY2t3MS1lbXB0eSIsIiIsIiIpXSxbXSxbXSwiYWxsIiwib2siLFtdLFsoImJ1aWxkZXIiLCJvayIpLCgibmFtZSIsImVtcHR5IiksKCJvdXQiLCIvbml4L3N0b3JlL3poaG5kOWdqZDRseXM3N3B5Mm05dzY5dnkxYm1ja3cxLWVtcHR5IiksKCJzeXN0ZW0iLCJhbGwiKV0pAQAAAAAAAAApAAAAAAAAAE5JWEUAAAAANQAAAAAAAAAvbml4L3N0b3JlLzk0NWpzYTQyOTR2aWZ5ODlrcDhna2JtdndnMHpuZDZxLWVtcHR5LmRydgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
with_closure := env_var_or_default("JUST_WITH_NIX_SHELL_CLOSURE", "false")
__with-maybe-nix-shell-closure cmd *args:
    #!/usr/bin/env -S sh -eu
    if [ "{{ with_closure }}" = "false" ] && [ ! -e nix-shell.closure ]; then
        if command -v nix-instantiate; then
            SHELLFILE="shell.nix"
            SHELL_DRV=`nix-instantiate $SHELLFILE`
            SHELL_INPUTS=`nix-store -qR --include-outputs $SHELL_DRV`
            nix-store --export $SHELL_INPUTS > nix-shell.closure
        else
            # stub out
            echo {{empty_closure}} | base64 -d - > nix-shell.closure
        fi
        export JUST_WITH_NIX_SHELL_CLOSURE=true
    fi
    just "{{ root_dir }}/{{ cmd }}" {{ args }}
    rm nix-shell.closure || true

# Create docker image (used to run tests)
docker name="mayon": (__with-maybe-nix-shell-closure "_docker" name)
_docker name="mayon":
    docker build -t {{name}} --network=host .

alias run := run-docker
# Run the test docker image
run-docker name="mayon":
    docker run -it --rm --net=host mayon bash
