"""Record, per benchmark pair and per compiler profile, whether the original and
the optimised contract compile to identical deployed bytecode.

A pair that compiles identically cannot differ at runtime, so any non-zero
figure the harness reports for it measures the harness rather than the rule.
`forge test --gas-report` also collapses such a pair into a single entry, which
is why some deployment rows are absent from summary.csv; this file records the
reason explicitly instead of leaving the absence to be inferred.
"""

import csv
import json
import pathlib
import sys

PAIRS = [
    ("Custom Errors", "k=1", "CustomErrorsBench.sol", "CE_A_1", "CE_Ao_1"),
    ("Custom Errors", "k=5", "CustomErrorsBench.sol", "CE_A_5", "CE_Ao_5"),
    ("Custom Errors", "k=20", "CustomErrorsBench.sol", "CE_A_20", "CE_Ao_20"),
    ("Unchecked Arithmetic", "arith100", "UncheckedBench.sol", "UA_A_Arith100", "UA_Ao_Arith100"),
    ("Unchecked Arithmetic", "arith1000", "UncheckedBench.sol", "UA_A_Arith1000", "UA_Ao_Arith1000"),
    ("Unchecked Arithmetic", "arith5000", "UncheckedBench.sol", "UA_A_Arith5000", "UA_Ao_Arith5000"),
    ("Unchecked Arithmetic", "sload100", "UncheckedBench.sol", "UA_A_Sload100", "UA_Ao_Sload100"),
    ("Unchecked Arithmetic", "sload1000", "UncheckedBench.sol", "UA_A_Sload1000", "UA_Ao_Sload1000"),
    ("Unchecked Arithmetic", "sload5000", "UncheckedBench.sol", "UA_A_Sload5000", "UA_Ao_Sload5000"),
    ("Payable Constructor", "minimal", "PayableCtorBench.sol", "PC_A_Min", "PC_Ao_Min"),
    ("Payable Constructor", "simple", "PayableCtorBench.sol", "PC_A_Simple", "PC_Ao_Simple"),
    ("Payable Constructor", "heavy", "PayableCtorBench.sol", "PC_A_Heavy", "PC_Ao_Heavy"),
    ("Named Returns", "one", "NamedReturnBench.sol", "NR_A_One", "NR_Ao_One"),
    ("Named Returns", "three", "NamedReturnBench.sol", "NR_A_Three", "NR_Ao_Three"),
    ("Named Returns", "struct", "NamedReturnBench.sol", "NR_A_Struct", "NR_Ao_Struct"),
]

PROFILES = {"default": "out", "viair": "out-viair"}


def deployed(out_dir, source, contract):
    for candidate in pathlib.Path(out_dir).rglob(f"{contract}.json"):
        if candidate.parent.name in (source, pathlib.Path(source).name):
            with candidate.open() as fh:
                return json.load(fh)["deployedBytecode"]["object"]
    return None


def main() -> None:
    out_path = sys.argv[1]
    rows = []
    for profile, out_dir in PROFILES.items():
        for pattern, size, source, a, ao in PAIRS:
            code_a = deployed(out_dir, source, a)
            code_ao = deployed(out_dir, source, ao)
            if code_a is None or code_ao is None:
                continue
            rows.append(
                {
                    "profile": profile,
                    "pattern": pattern,
                    "size": size,
                    "original_bytes": len(code_a) // 2 - 1,
                    "optimised_bytes": len(code_ao) // 2 - 1,
                    "identical": "yes" if code_a == code_ao else "no",
                }
            )

    with open(out_path, "w", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    main()
