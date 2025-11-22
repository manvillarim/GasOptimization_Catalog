# 23. Cache Storage Variables

This transformation caches storage variables in local memory variables before use in loops or multiple operations. Storage operations (SLOAD/SSTORE) are significantly more expensive than memory operations (MLOAD/MSTORE), so reducing the number of storage accesses by caching values in memory variables reduces gas consumption.

## Example

### Original (Repeated Storage Access)
```solidity
contract UncachedStorage {
    uint public total;
    uint public count;
    uint[] public numbers;
    
    function processNumbers() public {
        for (uint i = 0; i < numbers.length; i++) {
            total += numbers[i];  // Storage read and write each iteration
            count++;              // Storage read and write each iteration
        }
    }
    
    function updateTotal() public {
        total = 0;                // Storage write
        for (uint i = 0; i < numbers.length; i++) {
            total += numbers[i];  // Storage read and write each iteration
        }
    }
}
```

### Optimised (Cached Storage Variables)
```solidity
contract CachedStorage {
    uint public total;
    uint public count;
    uint[] public numbers;
    
    function processNumbers() public {
        // Cache storage variables in memory
        uint tempTotal = total;
        uint tempCount = count;
        
        for (uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i];  // Memory operations only
            tempCount++;
        }
        
        // Write back to storage once
        total = tempTotal;
        count = tempCount;
    }
    
    function updateTotal() public {
        uint tempTotal = 0;  // Memory variable
        
        for (uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i];  // Memory operations only
        }
        
        total = tempTotal;  // Single storage write
    }
}
```

## Gas Savings

Caching storage variables reduces gas consumption by minimizing expensive storage operations and performing cheaper memory operations instead, writing to storage only when necessary.