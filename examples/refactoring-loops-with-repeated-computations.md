# 5. Refactoring loops with repeated computations

This transformation addresses repeated computations within a loop that yield the same result in every iteration. Instead of recalculating the same expression multiple times, the computation is performed once before the loop begins and stored in a local variable. This reduces redundant operations and optimizes gas usage.

## Example

### Repeated Computations
```solidity
for (uint i=0;i<length;i++) {
    tokens[i] += limit × price;
}
```

### Optimized Loop

```solidity
uint local = limit × price;
for (uint i=0;i<length;i++) {
    tokens[i] += local;
}
```