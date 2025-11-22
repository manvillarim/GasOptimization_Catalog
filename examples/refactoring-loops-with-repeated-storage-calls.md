# 2. Refactoring Loops with Repeated Storage Calls

This transformation optimizes loops that repeatedly access storage variables by caching the storage value in a local variable before the loop, performing all operations on the cached value, and writing the result back to storage only once after the loop completes. This significantly reduces gas costs by minimizing expensive storage operations (SLOAD/SSTORE).

## Example

### Original (Repeated Storage Access)
```solidity
contract RepeatedStorageAccess {
    uint public total;
    uint[] public tokens;
    
    function sumTokens() public {
        for (uint i = 0; i < tokens.length; i++) {
            // Storage read and write in every iteration
            total += tokens[i];
        }
    }
}
```

### Optimised (Cached Storage Variable)
```solidity
contract CachedStorageAccess {
    uint public total;
    uint[] public tokens;
    
    function sumTokens() public {
        uint local = total;  // Single storage read
        for (uint i = 0; i < tokens.length; i++) {
            local += tokens[i];  // Memory operations only
        }
        total = local;  // Single storage write
    }
}
```

## Gas Savings

Caching storage variables before loops and writing back once after reduces gas consumption by replacing multiple expensive storage operations with a single read and single write, performing intermediate calculations in cheaper memory.