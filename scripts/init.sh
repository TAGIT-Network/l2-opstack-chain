#!/usr/bin/env bash
set -euo pipefail
[[ -f .env ]] || cp .env.example .env
make init
