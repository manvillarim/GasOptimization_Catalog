# Ensuring Gas Optimization Correctness by Behavioral Equivalence

## Authors

Manoel Felipe Araújo Villarim[0009-0005-6045-4519] - mfav@cin.ufpe.br

Juliano Manabu Iyoda[0000-0001-7137-8287] - jmi@cin.ufpe.br

Márcio Lopes Cornélio[0000-0002-9801-4659] - mlc2@cin.ufpe.br

Alexandre Cabral Mota[0000-0003-4416-8123] - acm@cin.ufpe.br

## Overview

This repository contains the artifacts from the work "Ensuring Gas Optimization Correctness by Behavioral Equivalence". The results are organized in the Gas Optimisation Catalogue. Each catalogue entry consists of:

1. **Definition**: Field with the definition of the transformation (via the generalization proposed in the article) or via example. The examples will be presented in generalization form in future work.

2. **CVL Specification**: Contains the link from the assembled specification to a specific example of the transformation. In cases where we identify outdated or incorrect rules, we have a link to before updating the transformation and another to after the update.

3. **Source**: Source of the non-original transformations from the paper.

**Artifact Structure:**
* `/certora`: Contains subdirectories for each optimization pattern with CVL specs and configuration files.
* `/definition`: PDF files formally defining the transformations.
* `/examples`: markdown files showing an example of the transformations.
* `/gas_check`: Project to verify gas savings under the proposed rules.
* `LICENSE.txt`: Licensing information.

## Requirements

All links for the certora verification (along with the corresponding specification) can be accessed in the corresponding catalog entry. If you want to replicate the experiment, go to the certora folder, then to the corresponding transformation subdirectory, and then to its conf folder. Use the command CertoraRun.py --prover_version master <NAME_OF_CONF_FILE>.conf.

# GAS OPTIMISATION CATALOGUE

| Rule | Definition/Example | CVL Specification | Source |
|---|---|---|---|
| Replace require with custom errors | [definition](definition/solidity_transformações-1.pdf) | [Spec](certora/replace-require-with-custom-errors/replace-require-with-custom-errors.md) | Original |
| Refactoring loops with repeated storage calls | [example](examples/refactoring-loops-with-repeated-storage-calls.md) | [Spec](certora/refactoring-loops-with-repeated-storage-calls/refactoring-loops-with-repeated-storage-calls.md) | [source](https://www.cs.toronto.edu/~fanl/papers/gas-brain21.pdf) |
| Refactoring loops with a constant comparison | [example](examples/refactoring-loops-with-a-constant-comparison.md) | [Spec](certora/refactoring-loops-with-a-constant-comparison/refactoring-loops-with-a-constant-comparison.md) | [source](https://www.cs.toronto.edu/~fanl/papers/gas-brain21.pdf) |
| Refactoring loops with repeated computations | [example](examples/refactoring-loops-with-repeated-computations.md) | [Spec](certora/refactoring-loops-with-repeated-computations/refactoring-loops-with-repeated-computations.md) | [source](https://www.cs.toronto.edu/~fanl/papers/gas-brain21.pdf) |
| Struct Packing | [example](examples/struct-packing.md) |[Spec](certora/struct-packing/struct-packing.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| State Variable Packing | [example](examples/state-variable-packing.md) | [Spec](certora/state-variable-packing/state-variable-packing.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Boolean Packing | [example](examples/boolean-packing.md) | [Spec](certora/boolean-packing/boolean-packing.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use fixed-size arrays instead of dynamic arrays | [example](examples/fixed-size-arrays.md) | [Spec](certora/fixed-size-arrays/fixed-size-arrays.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Avoid explicit zero initialization | [example](examples/avoid-zero-initialization.md) | [Spec](certora/avoid-zero-initialization/avoid-zero-initialization.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use calldata instead of memory for function parameters | [example](examples/calldata-vs-memory.md) | [Spec](certora/calldata-vs-memory/calldata-vs-memory.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Delete unused storage variables | [example](examples/delete-storage-variables.md) | [Spec](certora/delete-storage-variables/delete-storage-variables.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use appropriate function visibility | [example](examples/function-visibility.md) | [Spec](certora/function-visibility/function-visibility.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use constant variables for unchanging values | [example](examples/constant-variables.md) | [Spec](certora/constant-variables/constant-variables.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use immutable variables for constructor-set values | [example](examples/immutable-variables.md) | [Spec](certora/immutable-variables/immutable-variables.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Reduce mathematical expressions | [example](examples/reduce-expressions.md) | [Spec](certora/reduce-expressions/reduce-expressions.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use short-circuiting for conditional expressions | [example](examples/short-circuiting.md) | [Spec](certora/short-circuiting/short-circuiting.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Write values directly instead of calculating | [example](examples/write-values-directly.md) | [Spec](certora/write-values-directly/write-values-directly.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use single-line variable swapping | [definition](definition/solidity_transformações-18.pdf) | [Spec](certora/single-line-swap/single-line-swap.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Limit number of functions | [example](examples/limit-functions.md) | [Spec](certora/limit-functions/limit-functions.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Limit number of modifiers | [example](examples/limit-modifiers.md) | [Spec](certora/limit-modifiers/limit-modifiers.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Avoid nested loops | [example](examples/avoid-nested-loops.md) | [Spec](certora/avoid-nested-loops/avoid-nested-loops.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Combine multiple loops into one | [example](examples/combine-loops.md) | [Spec](certora/combine-loops/combine-loops.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Cache storage variables | [example](examples/cache-storage-variables.md) | [Spec](certora/cache-storage-variables/cache-storage-variables.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Cache array member variables | [example](examples/cache-member-variables.md) | [Spec](certora/cache-member-variables/cache-member-variables-verification.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Cache array length in loops | [example](examples/cache-array-length.md) | [Spec](certora/cache-array-length/cache-array-length.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use efficient loop increment (++ instead of +=1) | [example](examples/efficient-loop-increment.md) | [Spec](certora/efficient-loop-increment/efficient-loop-increment-verification.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use mappings instead of arrays for data lists | [example](examples/mappings-vs-arrays.md) | [Spec](certora/mappings-vs-arrays/mappings-vs-arrays.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Use unchecked arithmetic for validated operations  | [definition](definition/solidity_transformações-28.pdf) | [Spec](certora/unchecked/unchecked.md) | Original |
| Use Bytes instead of Strings  | [example](examples/string-bytes.md) | [Spec](certora/bytes-strings/bytes.md) | [source](https://ieeexplore.ieee.org/abstract/document/10429984) |
| Make Constructors Payable | [definition](definition/solidity_transformações-30.pdf) | [Spec](certora/constructor/constructor.md) | Original |