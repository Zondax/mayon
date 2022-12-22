alias default := _help
# Show this menu
@_help:
    just --list --unsorted

_new-deps:
    #!/usr/bin/env sh
    if ! command -v ffizer &> /dev/null
    then
        cargo install ffizer
    fi

# Create a new crate library
new destination: _new-deps
    ffizer apply -s .crate-ffizer -d crates/{{destination}}

# Clean up project files
clean:
    cargo clean

alias b := build
# Build project
build *args:
    cargo build {{args}}
