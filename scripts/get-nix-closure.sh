#!/usr/bin/env -S sh -eu

SHELLFILE=${1:-shell.nix}

EMPTY_CLOSURE="AQAAAAAAAAANAAAAAAAAAG5peC1hcmNoaXZlLTEAAAABAAAAAAAAACgAAAAAAAAABAAAAAAAAAB0eXBlAAAAAAcAAAAAAAAAcmVndWxhcgAIAAAAAAAAAGNvbnRlbnRz0AAAAAAAAABEZXJpdmUoWygib3V0IiwiL25peC9zdG9yZS96aGhuZDlnamQ0bHlzNzdweTJtOXc2OXZ5MWJtY2t3MS1lbXB0eSIsIiIsIiIpXSxbXSxbXSwiYWxsIiwib2siLFtdLFsoImJ1aWxkZXIiLCJvayIpLCgibmFtZSIsImVtcHR5IiksKCJvdXQiLCIvbml4L3N0b3JlL3poaG5kOWdqZDRseXM3N3B5Mm05dzY5dnkxYm1ja3cxLWVtcHR5IiksKCJzeXN0ZW0iLCJhbGwiKV0pAQAAAAAAAAApAAAAAAAAAE5JWEUAAAAANQAAAAAAAAAvbml4L3N0b3JlLzk0NWpzYTQyOTR2aWZ5ODlrcDhna2JtdndnMHpuZDZxLWVtcHR5LmRydgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

if command -v nix-instantiate > /dev/null 2>&1; then
    SHELL_DRV=$(nix-instantiate "$SHELLFILE")
    SHELL_INPUTS=$(nix-store -qR --include-outputs "$SHELL_DRV")

    # shellcheck disable=SC2086
    nix-store --export $SHELL_INPUTS
else
    # stub out
    echo $EMPTY_CLOSURE | base64 -d -
fi
