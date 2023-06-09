#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

set -euo pipefail

. ./constants.sh normal

dfx canister --network "${NETWORK}" call sns_governance list_proposals '(record {include_reward_status = vec {}; limit = 1; exclude_type = vec {}; include_status = vec {};})'
