"""Extract per-contract deployment cost and size from a gas report.

Reads a `forge test --gas-report` transcript on stdin and emits rows in the
schema used by run_benchmark.sh: profile,trial,kind,name,metric,value. Only the
benchmark contracts are emitted; test contracts and forge-std helpers are
skipped.

Usage:  forge test --gas-report | python3 script/parse_gas_report.py PROFILE TRIAL
"""

import re
import sys

PREFIXES = ("CE_", "UA_", "PC_", "NR_")


def main() -> None:
    profile, trial = sys.argv[1], sys.argv[2]
    text = sys.stdin.read()

    # Each report opens with a header line naming the contract; the first
    # numeric row that follows holds (deployment cost, deployment size).
    for block in re.split(r"\n(?=╭)", text):
        header = re.search(r"\|\s*\S+?:(\w+) Contract", block)
        if not header:
            continue
        name = header.group(1)
        if not name.startswith(PREFIXES):
            continue
        figures = re.search(
            r"Deployment Cost\s*\|\s*Deployment Size.*?\|\s*(\d+)\s*\|\s*(\d+)\s*\|",
            block,
            re.S,
        )
        if not figures:
            continue
        print(f"{profile},{trial},contract,{name},deploy_cost,{figures.group(1)}")
        print(f"{profile},{trial},contract,{name},deploy_size,{figures.group(2)}")


if __name__ == "__main__":
    main()
