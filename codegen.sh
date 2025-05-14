#! /usr/bin/env bash
set -e

mkdir -p offchain/types/
aiken build -t verbose
npx ~/cardano/voltaire/blaze-cardano/packages/blaze-blueprint plutus.json -o ./offchain/types/contracts.ts
