# 22. Avoid nested loops

This transformation eliminates nested loops by pre-computing complex operations off-chain or restructuring algorithms. Nested loops create exponential gas costs and should be avoided in smart contracts. Instead, computations should be done in external scripts and results passed as parameters.

## Example

### Nested Loops Pattern
```solidity
contract NestedLoops {
    uint[] public arrayA;
    uint[] public arrayB;
    uint public result;
    
    function computeMatrix() public {
        // Nested loops - very expensive!
        uint sum = 0;
        for(uint i = 0; i < arrayA.length; i++) {
            for(uint j = 0; j < arrayB.length; j++) {
                sum += arrayA[i] * arrayB[j];
            }
        }
        result = sum;
    }
    
    function findPairs() public view returns(uint count) {
        // Another nested loop example
        for(uint i = 0; i < arrayA.length; i++) {
            for(uint j = 0; j < arrayB.length; j++) {
                if(arrayA[i] == arrayB[j]) {
                    count++;
                }
            }
        }
    }
}
```

### Optimized No Nested Loops
```solidity
contract NoNestedLoops {
    uint[] public arrayA;
    uint[] public arrayB;
    uint public result;
    
    // Pre-compute off-chain and pass result
    function setPrecomputedResult(uint _result) public {
        result = _result;
    }
    
    // Use mapping for efficient lookups instead of nested loops
    mapping(uint => bool) private setB;
    
    function initializeSetB() public {
        for(uint i = 0; i < arrayB.length; i++) {
            setB[arrayB[i]] = true;
        }
    }
    
    function findPairs() public view returns(uint count) {
        // Single loop with O(1) lookup
        for(uint i = 0; i < arrayA.length; i++) {
            if(setB[arrayA[i]]) {
                count++;
            }
        }
    }
}
```