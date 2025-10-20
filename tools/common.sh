#!/usr/bin/env bash
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log() { echo -e "${GREEN}[ok]${NC} $*"; }
warn() { echo -t "${YELLOW}[warn]${NC} $*"; }
err() { echo -e "${RED}[err]${NC} $*"; }
require() { command -v "$1" >/dev/null 2>&1 || { err "$1 is required"; exit 1; }; }
