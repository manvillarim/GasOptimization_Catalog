# 26. Use Efficient Loop Increment (++ instead of +=1)

This transformation uses the pre-increment operator `++i` instead of the addition assignment `i += 1` in loops. The pre-increment operator generates slightly more efficient bytecode, reducing gas consumption per iteration. While the savings per iteration are small, they accumulate over many loop iterations.

## Example

### Original (Addition Assignment)
```solidity
contract InefficientIncrement {
    uint[] public data;
    
    function processData() public {
        for (uint i = 0; i < data.length; i += 1) {
            data[i] = data[i] * 2;
        }
    }
    
    function sumArray() public view returns (uint sum) {
        for (uint i = 0; i < data.length; i += 1) {
            sum += data[i];
        }
    }
}
```

### Optimised (Pre-increment)
```solidity
contract OptimizedIncrement {
    uint[] public data;
    
    function processData() public {
        for (uint i = 0; i < data.length; ++i) {
            data[i] = data[i] * 2;
        }
    }
    
    function sumArray() public view returns (uint sum) {
        for (uint i = 0; i < data.length; ++i) {
            sum += data[i];
        }
    }
}
```

## Gas Savings

Using `++i` instead of `i += 1` produces more efficient bytecode, reducing gas consumption per loop iteration. The savings are modest per iteration but accumulate in loops with many iterations.