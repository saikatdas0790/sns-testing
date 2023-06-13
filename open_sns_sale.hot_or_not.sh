#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

set -euo pipefail

. ./constants.sh normal

export SNS_SWAP_ID="$(dfx canister --network "${NETWORK}" id sns_swap)"

export DEADLINE=$(($(date +%s) + 86400 + 86400))
ic-admin   \
   --nns-url "${NETWORK_URL}" propose-to-open-sns-token-swap  \
   --test-neuron-proposer  \
   --min-participants 3  \
   --min-icp-e8s 100000000000000  \
   --max-icp-e8s 200000000000000  \
   --min-participant-icp-e8s 100000000  \
   --max-participant-icp-e8s 15000000000000  \
   --swap-due-timestamp-seconds "${DEADLINE}"  \
   --sns-token-e8s 33000000000000000  \
   --target-swap-canister-id "${SNS_SWAP_ID}"  \
   --community-fund-investment-e8s 50000000000000  \
   --neuron-basket-count 5  \
   --neuron-basket-dissolve-delay-interval-seconds 15778800  \
   --proposal-title "Decentralize this SNS"  \
   --summary "Decentralize this SNS"
