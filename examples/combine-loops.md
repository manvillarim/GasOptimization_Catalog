# 22. Combine Multiple Loops into One

This transformation merges multiple separate loops that iterate over the same range into a single loop. This reduces loop initialization overhead and the total number of iterations through the dataset, improving gas efficiency by performing all operations in a single pass.

## Example

### Original (Multiple Separate Loops)
```solidity
contract SeparateLoops {
    uint[] public numbers;
    uint public sum;
    uint public product;
    uint public count;
    
    function processArray() public {
        // First loop - calculate sum
        sum = 0;
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        
        // Second loop - calculate product
        product = 1;
        for (uint i = 0; i < numbers.length; i++) {
            product *= numbers[i];
        }
        
        // Third loop - count non-zero elements
        count = 0;
        for (uint i = 0; i < numbers.length; i++) {
            if (numbers[i] != 0) {
                count++;
            }
        }
    }
}
```

### Optimised (Combined Loop)
```solidity
contract CombinedLoop {
    uint[] public numbers;
    uint public sum;
    uint public product;
    uint public count;
    
    function processArray() public {
        // Single loop performing all calculations
        sum = 0;
        product = 1;
        count = 0;
        
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
            product *= numbers[i];
            if (numbers[i] != 0) {
                count++;
            }
        }
    }
}
```

## Gas Savings

Combining loops reduces gas consumption by eliminating redundant loop initialization and iteration overhead, processing the array in a single pass instead of multiple passes.