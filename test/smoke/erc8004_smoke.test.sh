#!/usr/bin/env bash
set -euo pipefail
bash tools/erc8004/smoke.sh --rpc ${L2_RPC:-http://localhost:9545} --agent-nft ${AGENT_PASSPORT_ERC721:-0x0000000000000000000000000000000000000000}
