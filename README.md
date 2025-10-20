# TAG IT NETWORK — l2-opstack-chain (OP Stack + EigenDA) with ERC-8004 readiness

This repo boots an OP Stack L2 (local) with optional EigenDA toggles. It includes:

- **Anchors check** (L1 → L2) to validate posting contracts
- **ERC-8004 checks**: CCIP route presence (optional), Agent Passport (ERC-721) smoke for read paths
- **Health probe**: blocks, finality, DA liveness
- Docker Compose stack, Make targets, CI with image_scan + sbom + sign (stubs)

## Quickstart
```bash
cp .env.example .env
make init   # generate jwt if missing, validate config
make up     # start op-geth/op-node and helpers
make logs   # tail logs
make smoke  # run ERC-8004 and health smoke tests
make down   # stop and clean
```

## Files

* `tools/anchors/check.sh` — sanity check that L1 anchor contract exists and is callable
* `tools/erc8004/check-routes.sh` — OPTIONAL CCIP route probe
* `tools/erc8004/smoke.sh` — basic read-only smoke vs Agent Passport + L2 RPC
* `tools/health/probe.sh` — checks for blocks, finality, and DA liveness

## Config

* `config/erc8004.json` — ERC-8004 endpoints, contract addresses (placeholders allowed)
* `ops/eigen/da.config.example.json` — example EigenDA toggle/config

## CI

* `ci.yml` builds, runs shell tests, stubs image scan/SBOM/signature

## Support

Open issues with logs from `make logs` and outputs from `make smoke`.

