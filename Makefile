SHELL := /bin/bash
.ONESHELL:

export $(shell sed -n 's/^[A-Z0-9_]*=.*/&/p' .env 2>/dev/null)

.PHONY: init up down logs smoke test clean

init:
@mkdir -p config tools scripts ops test
@if [ ! -f config/jwt.hex ]; then head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n' > config/jwt.hex; fi
@bash tools/anchors/check.sh --l1 $${L1_RPC} --anchor $${ANCHOR_ADDRESS} || true
@echo "Init complete."

up:
docker compose up -d

logs:
docker compose logs -f --tail=200

smoke:
bash tools/health/probe.sh --rpc $${L2_RPC} --check blocks,finality,da
bash tools/erc8004/smoke.sh --rpc $${L2_RPC} --agent-nft $${AGENT_PASSPORT_ERC721}

test: smoke

down:
docker compose down -v

clean: down
rm -rf config/jwt.hex
