#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

set -euo pipefail

export CONFIG="${1:-sns-test.yml}" && shift # consume the argument

. ./constants.sh normal

export CURRENT_DFX_IDENT="$(dfx identity whoami)"

dfx identity use "${DFX_IDENTITY}"

. ./setup_wallet.sh

dfx ledger --network "${NETWORK}" fabricate-cycles --canister "${WALLET}" --t 2345

ic-admin  \
   --nns-url "${NETWORK_URL}" propose-to-update-sns-deploy-whitelist  \
   --test-neuron-proposer  \
   --added-principals "${WALLET}"  \
   --proposal-title "Let me SNS!"  \
   --summary "This proposal whitelists developer's principal to deploy SNS"

dfx sns import
if [ "${CANISTER_TEST}" == "_test" ]
then
  curl -L "https://raw.githubusercontent.com/dfinity/ic/${IC_COMMIT}/rs/nns/governance/canister/governance_test.did" -o ./candid/nns-governance.did
  curl -L "https://raw.githubusercontent.com/dfinity/ic/${IC_COMMIT}/rs/sns/governance/canister/governance_test.did" -o ./candid/sns_governance.did
fi
sed "s/aaaaa-aa/${DFX_PRINCIPAL}/" "$CONFIG" > "${CONFIG}.tmp"
mv "${CONFIG}.tmp" "${CONFIG}"
sns-cli deploy --network "${NETWORK}" --init-config-file "${CONFIG}" --save-to ".dfx/${DFX_NETWORK}/canister_ids.json"

# Switch back to the previous identity
dfx identity use "$CURRENT_DFX_IDENT"
