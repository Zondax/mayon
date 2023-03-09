FROM nixos/nix:latest

WORKDIR /mayon
COPY . .

ENTRYPOINT nix --experimental-features 'nix-command flakes' develop \
    --command bash -c "cargo test"
