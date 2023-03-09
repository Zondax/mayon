FROM nixos/nix:latest

ENTRYPOINT nix --experimental-features 'nix-command flakes' develop \
    --command bash -c "cargo test"
