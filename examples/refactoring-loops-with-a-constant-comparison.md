# 4. Refactoring loops with a constant comparison

This transformation targets comparison operations within loops that always evaluate to a constant value. For example, if a condition inside the loop is always true, it introduces unnecessary overhead. The optimization consists of removing such constant conditions, simplifying the loop and reducing gas consumption.

## Example

### Constant Comparision
```solidity
uint x = 1;
for (uint i=0;i<length;i++) {
    if(x + i > 0) {
        total += tokens[i];
    }
}
```

### Optimized Loop

```solidity
uint x = 1;
for (uint i=0;i<length;i++) {
    total += tokens[i];
}
```