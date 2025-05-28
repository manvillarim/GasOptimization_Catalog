# GAS OPTIMIZATION CATALOG

This repository contains a series of transformations and techniques that aim to optimize gas consumption in solidity smart contracts.

| Transformation | Example | Approximate Gas Savings | Source |
|---|---|---|---|
| Replace require with custom errors | [example](examples/replace-require-with-custom-errors.md) | verificar | verificar |
| Replace dynamic arrays with mappings | [example](examples/replace-dynamic-arrays-with-mappings.md) | verificar | [source](https://ieeexplore.ieee.org/abstract/document/10429984?casa_token=sUZr-rcNR6EAAAAA:O7umjAqgUcAn7MeBgEQyHAVLXswsqWxqWRApNnohmvrftoqDah-WVghsCu1jV3ZHdCU5Bb4EXsQ)|
| Refactoring loops with repeated storage calls | [example](examples/refactoring-loops-with-repeated-storage-calls.md) | verificar | [source](https://www.cs.toronto.edu/~fanl/papers/gas-brain21.pdf) |
| Refactoring loops with a constant comparison | [example](examples/refactoring-loops-with-a-constant-comparison.md) | verificar | [source](https://www.cs.toronto.edu/~fanl/papers/gas-brain21.pdf) |
| Refactoring loops with repeated computations | [example](examples/refactoring-loops-with-repeated-computations.md) | verificar | [source](https://www.cs.toronto.edu/~fanl/papers/gas-brain21.pdf)  |
| Struct Packing | [example](examples/struct-packing.md) | verificar | [source](https://ieeexplore.ieee.org/abstract/document/10429984?casa_token=sUZr-rcNR6EAAAAA:O7umjAqgUcAn7MeBgEQyHAVLXswsqWxqWRApNnohmvrftoqDah-WVghsCu1jV3ZHdCU5Bb4EXsQ) |