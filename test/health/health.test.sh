#!/usr/bin/env bash
set -euo pipefail
bash tools/health/probe.sh --rpc ${L2_RPC:-http://localhost:9545} --check blocks,finality
