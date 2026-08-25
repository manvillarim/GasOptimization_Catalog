#!/usr/bin/env bash
# Benchmark driver for the four proposed rules.
#
# Runs each configuration TRIALS times over both compiler profiles, records
# every observation in results/raw.csv and aggregates them into
# results/summary.csv.
#
# Usage:  bash script/run_benchmark.sh [TRIALS]

set -euo pipefail

cd "$(dirname "$0")/.."

TRIALS="${1:-10}"
OUT=results
mkdir -p "$OUT"

RAW="$OUT/raw.csv"
echo "profile,trial,kind,name,metric,value" > "$RAW"

MATCH='test/proposed/*'

for profile in default viair; do
  # Clean build per profile; the profiles write to different out directories.
  FOUNDRY_PROFILE="$profile" forge build --root . >/dev/null 2>&1

  for trial in $(seq 1 "$TRIALS"); do
    log=$(FOUNDRY_PROFILE="$profile" forge test --gas-report --match-path "$MATCH" 2>&1)

    # Per-test gas: the cost of the single metered call.
    echo "$log" | grep -oE '\[PASS\] [A-Za-z0-9_]+\(\) \(gas: [0-9]+\)' \
      | sed -E 's/\[PASS\] ([A-Za-z0-9_]+)\(\) \(gas: ([0-9]+)\)/\1,\2/' \
      | while IFS=, read -r name value; do
          echo "$profile,$trial,test,$name,gas,$value" >> "$RAW"
        done

    # Per-contract deployment cost and size, from the gas report.
    echo "$log" | python3 script/parse_gas_report.py "$profile" "$trial" >> "$RAW"
  done
done

python3 script/aggregate.py "$RAW" "$OUT/summary.csv"

# Which pairs compile to identical deployed bytecode.
python3 script/bytecode_identity.py "$OUT/bytecode_identity.csv"

echo "raw observations  : $RAW"
echo "aggregates        : $OUT/summary.csv"
echo "bytecode identity : $OUT/bytecode_identity.csv"
