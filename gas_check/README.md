# Gas benchmarks

Foundry project backing the gas figures reported in *Ensuring Gas Optimisation
Correctness by Behavioural Equivalence*.

```
src/                     contracts for the outdated-pattern benchmarks
src/proposed/            contracts for the three rules proposed in the paper
test/                    tests for the outdated-pattern benchmarks
test/proposed/           tests for the three proposed rules
script/run_benchmark.sh  driver: repeated trials, both compiler profiles
script/parse_gas_report.py
script/aggregate.py
results/raw.csv          every individual observation
results/summary.csv      mean, standard deviation and saving per configuration
```

## Running

```shell
bash script/run_benchmark.sh 10     # 10 trials per configuration, both profiles
```

The driver writes `results/raw.csv` (one row per observation) and
`results/summary.csv` (aggregates). Nothing in the paper is read from a cached
artifact: `results/` is regenerated from a clean build on every invocation.

## Measurement protocol

**Two quantities, two instruments.** Deployment cost and runtime size come from
`forge test --gas-report`, which reports the `CREATE` gas and the deployed code
length per contract. Function cost comes from the per-test gas figure forge
prints for each test case. The two instruments answer different questions, and
mixing them within a single column would make the numbers incomparable.

**One metered call per test.** Every test that reports a function cost contains
exactly one call to the operation under study; anything else the test needs is
wrapped in `vm.pauseGasMetering` / `vm.resumeGasMetering`. This matters most for
the unchecked-arithmetic benchmark, whose `accumulate` workload writes N storage
slots before the measured call: at N = 5000 those `SSTORE`s cost roughly two
orders of magnitude more than the arithmetic under study, so leaving them inside
the metered region drives any reported saving towards zero.

**Compiler configurations.** `foundry.toml` defines two profiles that differ in
exactly one setting:

| Profile in the paper | `FOUNDRY_PROFILE` | solc | optimiser | runs | codegen |
|---|---|---|---|---|---|
| Standard | `default` | 0.8.22 | on | 200 | legacy |
| Via-IR | `viair` | 0.8.22 | on | 200 | Yul IR |

`solc` and `evm_version` are pinned so the numbers are reproducible, and the two
profiles write to different `out` directories so neither can serve the other a
stale artifact. Holding `optimizer_runs` fixed at 200 across both profiles is
what makes any difference between the columns attributable to the code
generator rather than to a different optimisation budget.

**Repeated trials.** Each configuration is measured over N trials (10 by
default) and every observation is kept in `results/raw.csv`. The EVM is
deterministic and forge replays each test from a fresh state, so the expected
standard deviation is zero; `summary.csv` carries the standard deviation
explicitly so that this can be checked rather than assumed. A non-zero value in
that column would indicate a defect in the harness, not measurement noise.

**Instance sizes.** Each proposed rule is measured at three points along the
dimension its saving is expected to depend on, so that a reader can distinguish
a per-occurrence effect from a one-off one:

| Rule | Dimension varied | Points |
|---|---|---|
| Custom Errors | number of guarded statements | k = 1, 5, 20 |
| Unchecked Arithmetic | loop trip count | N = 100, 1000, 5000 |
| Payable Constructor | constructor workload | minimal, simple, heavy |

The unchecked-arithmetic benchmark is additionally measured under two workloads
at every N: `decrementLoop`, whose body is pure arithmetic, and `accumulate`,
whose body is dominated by an `SLOAD`. The pair separates sensitivity to problem
size from sensitivity to the surrounding call pattern.

The payable-constructor benchmark keeps an unchanged runtime surface across all
six contracts, giving a control column that should show no effect; the residual
it does show bounds the resolution of the function-cost measurement.

## Reproducibility

The configuration used for the first submission pinned neither `solc` nor
`evm_version`, so the compiler in use was whatever the local `forge` resolved
for `pragma ^0.8.0`. Re-running that configuration against the *original*
benchmark sources reproduces every published deployment-cost and deployment-size
saving to within 0.62 percentage points, and reproduces the average-function
saving for five of the six rows. The sixth does not reproduce: unchecked
arithmetic under Via-IR was published at -1.42 %, while solc 0.8.20, 0.8.22,
0.8.26 and 0.8.31 give -0.97 %, -0.77 %, -0.67 % and -0.67 % respectively. That
column is unusually sensitive to the compiler version, and the absence of a
compiler pin in the original configuration is the reason the published value
cannot be recovered. Pinning the compiler removes this class of drift.

The "Standard" column of that table was described in the first submission as
using no optimisation. Reproduction shows it corresponds to the optimiser
enabled at 200 runs through the legacy code generator; the profile above is
named and documented accordingly.
