#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

set -euo pipefail

. ./constants.sh normal

export DEVELOPER_NEURON_ID="$(dfx canister --network "${NETWORK}" call sns_governance list_neurons "(record {of_principal = opt principal\"${DX_PRINCIPAL}\"; limit = 1})" | grep "^ *id = blob" | sed "s/^ *id = \(.*\);$/'(\1)'/" | xargs didc encode | tail -c +21)"

export CID="$(dfx canister --network "${NETWORK}" id test)"
quill sns  \
   --canister-ids-file ./sns_canister_ids.json  \
   --pem-file "${PEM_FILE}"  \
   make-proposal --proposal "(record { title=\"Register generic functions for test canister.\"; url=\"https://example.com/\"; summary=\"This proposals registers generic functions for test canister.\"; action=opt variant {AddGenericNervousSystemFunction = record {id=2000:nat64; name=\"execute\"; description=\"set parameters of test canisters\"; function_type=opt variant {GenericNervousSystemFunction=record{validator_canister_id=opt principal\"$CID\"; target_canister_id=opt principal\"$CID\"; validator_method_name=opt\"validate\"; target_method_name=opt\"execute\"}}}}})" $DEVELOPER_NEURON_ID > msg.json
quill --insecure-local-dev-mode send --yes msg.json
