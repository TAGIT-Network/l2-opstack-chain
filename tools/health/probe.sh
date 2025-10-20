#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../common.sh"

usage() { echo "Usage: $0 --rpc <l2_rpc> --check blocks,finality,da"; exit 2; }
RPC=""; CHECKS="";
while [[ $# -gt 0 ]]; do case $1 in
  --rpc) RPC="$2"; shift 2;;
  --check) CHECKS="$2"; shift 2;;
  *) usage;; esac; done
[[ -z "$RPC" || -z "$CHECKS" ]] && usage
require curl

get_block() {
  curl -s -X POST "$RPC" -H 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false],"id":1}' | jq -r '.result.number'
}

IFS=',' read -ra CS <<< "$CHECKS"
for C in "${CS[@]}"; do
  case "$C" in
    blocks)
      B=$(get_block)
      [[ "$B" == "null" ]] && { err "no blocks"; exit 1; } || log "latest block=$B";;
    finality)
      # Placeholder heuristic: ensure block number advances across two polls
      B1=$(get_block); sleep 2; B2=$(get_block)
      [[ "$B1" == "$B2" ]] && { warn "no movement — check consensus"; } || log "blocks advancing";;
    da)
      if [[ -f ops/eigen/da.config.json ]]; then log "EigenDA config present"; else warn "DA not enabled"; fi;;
    *) warn "unknown check: $C";;
  esac
done
