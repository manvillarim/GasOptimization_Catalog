#!/usr/bin/env bash
# Reconstructed benchmark driver for the three proposed rules.
#
# WHY REPEATED TRIALS. A reviewer cannot tell, from a single reported number,
# whether a measurement is exact or the first draw of a noisy process. This
# script executes each configuration TRIALS times and records every individual
# observation in results/raw.csv, so the aggregate in results/summary.csv can
# be audited and the standard deviation inspected rather than asserted. The EVM
# is deterministic and forge replays each test from a fresh state, so the
# expected outcome is a zero standard deviation; the point is to demonstrate
# that, not to assume it.
#
# WHY BOTH PROFILES ARE DRIVEN FROM ONE SCRIPT. The Standard and Via-IR columns
# must differ in exactly one setting. Selecting them through FOUNDRY_PROFILE
# against the two profiles in foundry.toml, rather than by hand-editing the
# config between runs, is what guarantees that.
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
  # A clean build per profile; the two profiles write to different out
  # directories so neither can serve the other a stale artifact.
  FOUNDRY_PROFILE="$profile" forge build --root . >/dev/null 2>&1

  for trial in $(seq 1 "$TRIALS"); do
    log=$(FOUNDRY_PROFILE="$profile" forge test --gas-report --match-path "$MATCH" 2>&1)

    # Per-test gas: the metered cost of the single operation under study.
    echo "$log" | grep -oE '\[PASS\] [A-Za-z0-9_]+\(\) \(gas: [0-9]+\)' \
      | sed -E 's/\[PASS\] ([A-Za-z0-9_]+)\(\) \(gas: ([0-9]+)\)/\1,\2/' \
      | while IFS=, read -r name value; do
          echo "$profile,$trial,test,$name,gas,$value" >> "$RAW"
        done

    # Per-contract deployment cost and runtime size, from the gas report.
    echo "$log" | python3 script/parse_gas_report.py "$profile" "$trial" >> "$RAW"
  done
done

python3 script/aggregate.py "$RAW" "$OUT/summary.csv"

# Which pairs compile to identical runtime code. A pair that does cannot differ
# at runtime, so its reported function-gas difference bounds the resolution of
# the function-cost instrument.
python3 script/bytecode_identity.py "$OUT/bytecode_identity.csv"

echo "raw observations  : $RAW"
echo "aggregates        : $OUT/summary.csv"
echo "bytecode identity : $OUT/bytecode_identity.csv"
