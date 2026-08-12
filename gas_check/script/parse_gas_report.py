"""Extract per-contract deployment cost and runtime size from a gas report.

Reads a `forge test --gas-report` transcript on stdin and emits CSV rows in the
schema used by run_benchmark.sh: profile,trial,kind,name,metric,value.

Only the benchmark contracts are emitted. Test contracts and forge-std helpers
carry no deployment figure that belongs in the results, and including them
would silently pollute any aggregate computed over the file.
"""

import re
import sys

PREFIXES = ("CE_", "UA_", "PC_", "NR_")


def main() -> None:
    profile, trial = sys.argv[1], sys.argv[2]
    text = sys.stdin.read()

    # Each contract's report opens with a header line naming it, and the first
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
