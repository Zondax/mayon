#!/usr/bin/env -S sh -eu

BASE_DIR=$(dirname "$0")

NAME=${1:-mayon}

echo "Building docker image with tag \"${NAME}\""

# Get NIX store closure
"$BASE_DIR"/get-nix-closure.sh "$(pwd)/shell.nix" > nix-shell.closure

# build docker image
docker build -t "$NAME" --network=host .

# remove closure
rm nix-shell.closure
