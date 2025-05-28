# 25. Cache storage variables in loops

This transformation caches storage variables in local memory variables before loop execution. Since storage operations (SSTORE/SLOAD) are expensive, especially when performed repeatedly in loops, caching them in memory significantly reduces gas consumption.

## Example

### Storage Access in Loop
```solidity
contract StorageInLoop {
    uint public total;
    uint public count;
    uint[] public numbers;
    
    function processNumbers() public {
        for(uint i = 0; i < numbers.length; i++) {
            total += numbers[i];  // Storage write in every iteration
            count++;             // Storage write in every iteration
            
            if(total > 1000) {
                total = total / 2; // Additional storage operations
            }
        }
    }
    
    function calculateAverage() public {
        total = 0; // Storage write
        for(uint i = 0; i < numbers.length; i++) {
            total += numbers[i]; // Storage read and write each iteration
        }
    }
}
```

### Optimized Cached Storage Variables
```solidity
contract CachedStorage {
    uint public total;
    uint public count;
    uint[] public numbers;
    
    function processNumbers() public {
        // Cache storage variables in memory
        uint tempTotal = total;
        uint tempCount = count;
        
        for(uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i]; // Memory operation
            tempCount++;            // Memory operation
            
            if(tempTotal > 1000) {
                tempTotal = tempTotal / 2; // Memory operation
            }
        }
        
        // Write back to storage once
        total = tempTotal;
        count = tempCount;
    }
    
    function calculateAverage() public {
        uint tempTotal = 0; // Local variable
        
        for(uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i]; // Only memory operations in loop
        }
        
        total = tempTotal; // Single storage write
    }
}
```