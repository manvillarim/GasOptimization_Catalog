# 3. Loops with repeated storage calls

This transformation aims to optimize gas usage in loops that access storage variables. Instead of performing multiple storage reads and writes in each iteration — which are costly — the value is loaded once into a local variable, updated throughout the loop, and then written back to storage at the end. This reduces the number of storage operations to just two.

## Example

### Repeated Storage Calls
```solidity
for(uint i = 0; i < length; i++) {
    total += tokens[i];
}
```

### Optimized Loop

```solidity
uint local = total;
for(uint i = 0; i < length; i++) {
    local += tokens[i];
}
total = local;
```