#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../common.sh"

# Optional CCIP route check. Pass if absent; warn only.
CFG=./config/erc8004.json
if [[ ! -f "$CFG" ]]; then warn "erc8004.json not found"; exit 0; fi
RID=$(jq -r '.ccipRouteId // ""' "$CFG")
if [[ -z "$RID" || "$RID" == "[CHAINLINK_CCIP_ROUTE_ID]" ]]; then
  warn "No CCIP route configured — skipping"
  exit 0
fi
log "CCIP route present: $RID"
