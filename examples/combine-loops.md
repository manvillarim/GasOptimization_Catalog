# 23. Combine multiple loops into one

This transformation merges multiple separate loops that iterate over the same range into a single loop. This reduces the total number of iterations and loop initialization overhead, resulting in significant gas savings when processing large datasets.

## Example

### Multiple Separate Loops
```solidity
contract SeparateLoops {
    uint[] public numbers;
    uint public sum;
    uint public product;
    uint public count;
    
    function processArray() public {
        // First loop - calculate sum
        sum = 0;
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        
        // Second loop - calculate product
        product = 1;
        for(uint i = 0; i < numbers.length; i++) {
            product *= numbers[i];
        }
        
        // Third loop - count non-zero elements
        count = 0;
        for(uint i = 0; i < numbers.length; i++) {
            if(numbers[i] != 0) {
                count++;
            }
        }
    }
}
```

### Optimized Combined Loop
```solidity
contract CombinedLoop {
    uint[] public numbers;
    uint public sum;
    uint public product;
    uint public count;
    
    function processArray() public {
        // Single loop doing all calculations
        sum = 0;
        product = 1;
        count = 0;
        
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];        // Calculate sum
            product *= numbers[i];    // Calculate product
            if(numbers[i] != 0) {     // Count non-zero elements
                count++;
            }
        }
    }
}
```