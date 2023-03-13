FROM nixos/nix:latest

WORKDIR /mayon
COPY . .

RUN nix-store --import < nix-shell.closure
RUN rm nix-shell.closure

# Prepare build environment and prefetch dependencies
RUN nix-shell --run "cargo fetch"

ENTRYPOINT nix-shell
