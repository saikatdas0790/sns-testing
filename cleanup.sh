#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
# for the sake of redeployment (e.g., within the same Docker instance)

set -euo pipefail

. ./constants.sh install

cp dfx.json.orig dfx.json
cp sns-test.yml.orig sns-test.yml

rm -rf .dfx candid/assets.did candid/nns-* candid/sns_* \
*.wasm *.wasm.gz \
nns-dapp/out nns-dapp/.dfx/* nns-dapp/canister_ids.json nns-dapp/*.wasm nns-dapp/*.wasm.gz \
internet-identity/.dfx msg.json sns_canister_ids.json

# Remove Wallets
rm -rf ~/.local/share/dfx/network/${NETWORK}/wallets.json
rm -rf ~/Library/Application\ Support/org.dfinity.dfx/network/${NETWORK}/wallets.json

# Remove any generated quill messages
rm -rf msg_*.json

