"""Aggregate raw benchmark observations into mean, standard deviation and savings.

Consumes the raw.csv written by run_benchmark.sh and produces summary.csv with
one row per (profile, metric, pattern, size), carrying the original and the
optimised measurement, the standard deviation of each across trials, and the
relative saving.

The standard deviation is carried into the output even when it is zero. A zero
here is a result -- it says the measurement is exact rather than sampled -- and
dropping the column would hide the very property the reviewer asked us to
establish.
"""

import csv
import statistics
import sys
from collections import defaultdict

# (pattern, size) keyed by the contract or test name produced by the benchmark.
CONTRACTS = {
    "CE_A_1": ("Custom Errors", "k=1", "A"),
    "CE_Ao_1": ("Custom Errors", "k=1", "Ao"),
    "CE_A_5": ("Custom Errors", "k=5", "A"),
    "CE_Ao_5": ("Custom Errors", "k=5", "Ao"),
    "CE_A_20": ("Custom Errors", "k=20", "A"),
    "CE_Ao_20": ("Custom Errors", "k=20", "Ao"),
    "UA_A_Arith100": ("Unchecked Arithmetic", "arith100", "A"),
    "UA_Ao_Arith100": ("Unchecked Arithmetic", "arith100", "Ao"),
    "UA_A_Arith1000": ("Unchecked Arithmetic", "arith1000", "A"),
    "UA_Ao_Arith1000": ("Unchecked Arithmetic", "arith1000", "Ao"),
    "UA_A_Arith5000": ("Unchecked Arithmetic", "arith5000", "A"),
    "UA_Ao_Arith5000": ("Unchecked Arithmetic", "arith5000", "Ao"),
    "UA_A_Sload100": ("Unchecked Arithmetic", "sload100", "A"),
    "UA_Ao_Sload100": ("Unchecked Arithmetic", "sload100", "Ao"),
    "UA_A_Sload1000": ("Unchecked Arithmetic", "sload1000", "A"),
    "UA_Ao_Sload1000": ("Unchecked Arithmetic", "sload1000", "Ao"),
    "UA_A_Sload5000": ("Unchecked Arithmetic", "sload5000", "A"),
    "UA_Ao_Sload5000": ("Unchecked Arithmetic", "sload5000", "Ao"),
    "PC_A_Min": ("Payable Constructor", "minimal", "A"),
    "PC_Ao_Min": ("Payable Constructor", "minimal", "Ao"),
    "PC_A_Simple": ("Payable Constructor", "simple", "A"),
    "PC_Ao_Simple": ("Payable Constructor", "simple", "Ao"),
    "PC_A_Heavy": ("Payable Constructor", "heavy", "A"),
    "PC_Ao_Heavy": ("Payable Constructor", "heavy", "Ao"),
    "NR_A_One": ("Named Returns", "one", "A"),
    "NR_Ao_One": ("Named Returns", "one", "Ao"),
    "NR_A_Three": ("Named Returns", "three", "A"),
    "NR_Ao_Three": ("Named Returns", "three", "Ao"),
    "NR_A_Struct": ("Named Returns", "struct", "A"),
    "NR_Ao_Struct": ("Named Returns", "struct", "Ao"),
}


def classify_test(name):
    """Map a test-case name onto (pattern, size, version, workload)."""
    parts = name.split("_")
    if parts[1] == "CustomErrors":
        return "Custom Errors", parts[2], parts[3], parts[4]
    if parts[1] == "Unchecked":
        return "Unchecked Arithmetic", parts[2], parts[3], parts[4]
    if parts[1] == "PayableCtor":
        return "Payable Constructor", parts[2], parts[3], parts[4]
    if parts[1] == "NamedReturn":
        return "Named Returns", parts[2], parts[3], parts[4]
    return None


def main() -> None:
    raw_path, out_path = sys.argv[1], sys.argv[2]
    samples = defaultdict(list)

    with open(raw_path) as fh:
        for row in csv.DictReader(fh):
            value = int(row["value"])
            if row["kind"] == "contract":
                meta = CONTRACTS.get(row["name"])
                if meta is None:
                    continue
                pattern, size, version = meta
                key = (row["profile"], row["metric"], pattern, size, "-", version)
            else:
                meta = classify_test(row["name"])
                if meta is None:
                    continue
                pattern, size, version, workload = meta
                key = (row["profile"], "fn_gas", pattern, size, workload, version)
            samples[key].append(value)

    rows = []
    seen = set()
    for key in samples:
        profile, metric, pattern, size, workload, _ = key
        head = (profile, metric, pattern, size, workload)
        if head in seen:
            continue
        seen.add(head)
        a = samples.get(head + ("A",))
        ao = samples.get(head + ("Ao",))
        if not a or not ao:
            continue
        mean_a, mean_ao = statistics.fmean(a), statistics.fmean(ao)
        rows.append(
            {
                "profile": profile,
                "metric": metric,
                "pattern": pattern,
                "size": size,
                "workload": workload,
                "trials": len(a),
                "original_mean": f"{mean_a:.2f}",
                "original_sd": f"{statistics.pstdev(a):.4f}",
                "optimised_mean": f"{mean_ao:.2f}",
                "optimised_sd": f"{statistics.pstdev(ao):.4f}",
                "saving_pct": f"{100.0 * (mean_ao - mean_a) / mean_a:.2f}",
            }
        )

    rows.sort(key=lambda r: (r["pattern"], r["metric"], r["size"], r["workload"], r["profile"]))
    with open(out_path, "w", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    main()
