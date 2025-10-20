#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../common.sh"

usage() { echo "Usage: $0 --rpc <l2_rpc> --agent-nft <address>"; exit 2; }
RPC=""; NFT="";
while [[ $# -gt 0 ]]; do case $1 in
  --rpc) RPC="$2"; shift 2;;
  --agent-nft) NFT="$2"; shift 2;;
  *) usage;; esac; done
[[ -z "$RPC" || -z "$NFT" ]] && usage

require curl

# Read-only token name() and totalSupply() if available
DATA_NAME="0x06fdde03"   # name()
DATA_SUPPLY="0x18160ddd" # totalSupply()

call() {
  local DATA="$1"
  curl -s -X POST "$RPC" -H 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'"$NFT"'","data":"'"$DATA"'"},"latest"],"id":1}' | jq -r '.result'
}

NAME=$(call $DATA_NAME)
SUPPLY=$(call $DATA_SUPPLY || true)
log "Agent NFT: name(raw)=$NAME supply(raw)=${SUPPLY:-n/a}"
