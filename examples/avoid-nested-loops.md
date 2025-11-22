# 21. Avoid Nested Loops

This transformation eliminates nested loops by restructuring algorithms or pre-computing results off-chain. Nested loops create quadratic time complexity, leading to prohibitively high gas costs.

## Example

### Original (with Nested Loops)
```solidity
contract NestedLoops {
    uint[] public items;
    uint[] public prices;
    
    // Nested loop - O(n²) complexity
    function calculateTotalCost() public view returns (uint total) {
        for (uint i = 0; i < items.length; i++) {
            for (uint j = 0; j < prices.length; j++) {
                if (items[i] == j) {
                    total += prices[j];
                }
            }
        }
    }
}
```

### Optimised (without Nested Loops)
```solidity
contract NoNestedLoops {
    uint[] public items;
    mapping(uint => uint) public prices;
    
    // Single loop with O(1) mapping lookup - O(n) complexity
    function calculateTotalCost() public view returns (uint total) {
        for (uint i = 0; i < items.length; i++) {
            total += prices[items[i]];
        }
    }
}
```

## Gas Savings

Replacing the inner loop with a mapping lookup reduces complexity from O(n²) to O(n), significantly reducing gas costs as array sizes grow.