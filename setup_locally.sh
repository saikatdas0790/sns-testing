#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

set -euo pipefail

. ./constants.sh normal

for canister in cycles-minting-canister genesis-token-canister governance-canister governance-canister_test ic-ckbtc-minter identity-canister ledger-canister_notify-method lifeline_canister nns-ui-canister registry-canister root-canister sns-wasm-canister sns-root-canister "sns-governance-canister${CANISTER_TEST}" sns-swap-canister ic-icrc1-ledger ic-icrc1-archive ic-icrc1-index
do
  curl -L "https://download.dfinity.systems/ic/${IC_COMMIT}/canisters/${canister}.wasm.gz" -o "${canister}.wasm.gz"
  gzip -d "${canister}.wasm.gz"
done
if [ ! -z "${CANISTER_TEST}" ]
then
  mv "./sns-governance-canister${CANISTER_TEST}.wasm" ./sns-governance-canister.wasm
fi

dfx nns import
dfx sns import
if [ "${CANISTER_TEST}" == "_test" ]
then
  curl -L "https://raw.githubusercontent.com/dfinity/ic/${IC_COMMIT}/rs/nns/governance/canister/governance_test.did" -o ./candid/nns-governance.did
  curl -L "https://raw.githubusercontent.com/dfinity/ic/${IC_COMMIT}/rs/sns/governance/canister/governance_test.did" -o ./candid/sns_governance.did
fi

ic-nns-init --initialize-ledger-with-test-accounts-for-principals "${DX_PRINCIPAL}" --initialize-ledger-with-test-accounts 5b315d2f6702cb3a27d826161797d7b2c2e131cd312aece51d4d5574d1247087 --initialize-ledger-with-test-accounts 2b8fbde99de881f695f279d2a892b1137bfe81a42d7694e064b1be58701e1138 --url "${NETWORK_URL}" --initial-neurons initial_neurons.csv --pass-specified-id

./setup.sh
