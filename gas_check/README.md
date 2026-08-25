# Gas benchmarks

Foundry project that produces the gas figures reported in *Ensuring Gas
Optimisation Correctness by Behavioural Equivalence*.

## Layout

```
src/                         contracts for the outdated-pattern benchmarks
src/proposed/                contracts for the four proposed rules
test/                        tests for the outdated-pattern benchmarks
test/proposed/               tests for the four proposed rules
script/run_benchmark.sh      benchmark driver
script/parse_gas_report.py   reads deployment cost and size from the gas report
script/aggregate.py          computes mean, standard deviation and saving
script/bytecode_identity.py  compares the deployed bytecode of each pair
results/                     generated output
```

## Requirements

* Foundry (tested with forge 1.7.1)
* Python 3, standard library only
* solc 0.8.22, fetched automatically by forge on the first build

## Running

From this directory:

```shell
bash script/run_benchmark.sh 10
```

The argument is the number of trials per configuration and defaults to 10. Each
profile is rebuilt from scratch before its trials, so no figure is read from a
cached artifact. The run overwrites three files:

| File | Contents |
|---|---|
| `results/raw.csv` | one row per observation: `profile,trial,kind,name,metric,value` |
| `results/summary.csv` | one row per `(profile, metric, pattern, size, workload)`, with `original_mean`, `original_sd`, `optimised_mean`, `optimised_sd`, `saving_pct` |
| `results/bytecode_identity.csv` | one row per pair and profile, with `original_bytes`, `optimised_bytes`, `identical` |

`metric` is `deploy_cost`, `deploy_size` or `fn_gas`. `saving_pct` is
`100 * (optimised_mean - original_mean) / original_mean`, so a negative value is
a saving.

`summary.csv` and `bytecode_identity.csv` are byte-identical across runs. The
rows of `raw.csv` carry the same observations but not in the same order, because
forge does not fix the order in which it runs the test contracts; sort the file
before diffing it against a previous run.

To read the raw gas report for one profile:

```shell
FOUNDRY_PROFILE=default forge test --gas-report --match-path 'test/proposed/*'
FOUNDRY_PROFILE=viair   forge test --gas-report --match-path 'test/proposed/*'
```

To measure a single instance:

```shell
FOUNDRY_PROFILE=viair forge test --match-test test_Unchecked_arith5000 -vv
```

Test names follow `test_<rule>_<size>_<version>_<workload>`, where `<version>`
is `A` for the original contract and `Ao` for the optimised one. `aggregate.py`
pairs observations by this name, so renaming a test changes the aggregation.

## Compiler profiles

`foundry.toml` defines two profiles that differ in one setting:

| Column in the paper | `FOUNDRY_PROFILE` | solc | evm_version | optimiser | runs | codegen |
|---|---|---|---|---|---|---|
| Standard | `default` | 0.8.22 | shanghai | on | 200 | legacy |
| Via-IR | `viair` | 0.8.22 | shanghai | on | 200 | Yul IR |

`solc` and `evm_version` are pinned so that a re-run reproduces the same
numbers. The profiles write to `out/` and `out-viair/`, so neither can serve the
other a stale artifact. Holding `optimizer_runs` at 200 in both makes any
difference between the two columns attributable to the code generator.

## Measurement protocol

Deployment cost and deployment size come from `forge test --gas-report`. The
size reported there is the length of the creation (init) code, not of the
runtime code, so a rule that touches only the constructor still shows up in that
column.

Function cost comes from the per-test gas figure forge prints for each test
case. Every test that reports a function cost makes exactly one metered call;
setup work such as seeding storage slots is wrapped in `vm.pauseGasMetering` and
`vm.resumeGasMetering`.

Each configuration is measured over N trials and every observation is kept in
`results/raw.csv`. EVM execution is deterministic and forge replays each test
from a fresh state, so `original_sd` and `optimised_sd` are expected to be
`0.0000`. A non-zero value in those columns indicates a fault in the harness.

`results/bytecode_identity.csv` records whether the two contracts of a pair
compile to identical deployed bytecode. A pair that does cannot differ at
runtime, and `forge test --gas-report` collapses it into a single entry, which
is why some deployment rows are absent from `summary.csv`.

## Instance sizes

Each rule is measured at three points along the dimension its saving depends on:

| Rule | Dimension varied | Instances |
|---|---|---|
| Custom Errors | number of guarded statements | k = 1, 5, 20 |
| Unchecked Arithmetic | loop trip count and loop body | N = 100, 1000, 5000, with an arithmetic body and an `SLOAD` body at each N |
| Payable Constructor | constructor workload | minimal, simple, heavy (64 storage slots) |
| Named Returns | width of the returned value | one word, three words, eight-field struct |

The trip count of the unchecked-arithmetic benchmark is a compile-time
constant, so each of its six instances is a contract pair of its own and carries
its own deployment figures.

The six payable-constructor contracts expose the same runtime surface, so the
function-gas rows for that rule act as a control and are expected to show no
difference.
