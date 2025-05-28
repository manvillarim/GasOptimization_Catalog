# 24. Avoid repetitive arithmetic operations in loops

This transformation moves arithmetic operations that don't depend on the loop variable outside the loop. Since arithmetic opcodes consume gas, performing them repeatedly inside loops multiplies the gas cost by the number of iterations.

## Example

### Repetitive Arithmetic in Loop
```solidity
contract RepetitiveArithmetic {
    uint[] public data;
    uint public baseValue = 100;
    uint public multiplier = 5;
    
    function processData() public {
        for(uint i = 0; i < data.length; i++) {
            // Repetitive calculation inside loop
            uint threshold = baseValue * multiplier + 50; // Calculated every iteration
            uint factor = multiplier * 2 + 10;           // Calculated every iteration
            
            if(data[i] > threshold) {
                data[i] = data[i] * factor / 100;
            }
        }
    }
    
    function calculateTotals() public view returns(uint total) {
        for(uint i = 0; i < data.length; i++) {
            // Division operation repeated in loop
            total += data[i] * baseValue / multiplier; // Division every iteration
        }
    }
}
```

### Optimized Arithmetic Outside Loop
```solidity
contract OptimizedArithmetic {
    uint[] public data;
    uint public baseValue = 100;
    uint public multiplier = 5;
    
    function processData() public {
        // Pre-calculate constants outside loop
        uint threshold = baseValue * multiplier + 50; // Calculated once
        uint factor = multiplier * 2 + 10;           // Calculated once
        
        for(uint i = 0; i < data.length; i++) {
            if(data[i] > threshold) {
                data[i] = data[i] * factor / 100;
            }
        }
    }
    
    function calculateTotals() public view returns(uint total) {
        // Pre-calculate to avoid division in loop
        uint multipliedBase = baseValue * 1000; // Multiply instead of divide
        
        for(uint i = 0; i < data.length; i++) {
            total += data[i] * multipliedBase / (multiplier * 1000);
        }
    }
}
```