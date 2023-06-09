#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

set -uo pipefail

. ./constants.sh normal

CANISTER_NAME="${1:-nns-dapp}"
URL_PATH="${2:-}"

CANISTER_ID=""

function get_canister_id() {
    local DIR=$1
    cd "${DIR}" || exit
    dfx canister --network "${NETWORK}" id "${CANISTER_NAME}" 2> /dev/null
}


for DFX_DIR in $(find . -name "*.dfx");do
      CANISTER_ID=$(get_canister_id "${DFX_DIR}")
      if [[ -n "${CANISTER_ID}" ]]; then
        break
      fi

done


if [[ -n "${CANISTER_ID}" ]]; then
    echo "Open the following link in a browser"
    echo "${PROTOCOL}://${CANISTER_ID}.${HOST_ENDPOINT}/${URL_PATH}"
    exit 0
else
  echo "Canister ${CANISTER_NAME} is an unknown canister name"
  exit 1
fi

