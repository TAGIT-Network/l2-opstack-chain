#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../common.sh"

usage() { echo "Usage: $0 --l1 <rpc> --anchor <address>"; exit 2; }
L1=""; A="";
while [[ $# -gt 0 ]]; do case $1 in
  --l1) L1="$2"; shift 2;;
  --anchor) A="$2"; shift 2;;
  *) usage;; esac; done
[[ -z "$L1" || -z "$A" ]] && usage

require curl

# Simple eth_call to check code at anchor address
CODE=$(curl -s -X POST "$L1" \
  -H 'Content-Type: application/json' \
  --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["'"$A"'","latest"],"id":1}')
if [[ "$CODE" == *"0x"* && "$CODE" != *"0x\"}"* ]]; then
  log "Anchor $A present on L1"
else
  err "No code at anchor $A on L1"
  exit 1
fi
