# 3. Refactoring Loops with Constant Comparison

This transformation removes redundant conditional checks within loops that always evaluate to the same constant value. When a condition is always true (or always false) due to the values involved, the check serves no purpose and only consumes gas. Eliminating these constant comparisons simplifies the loop and reduces gas consumption.

## Example

### Original (Constant Comparison)
```solidity
contract ConstantComparison {
    uint[] public tokens;
    
    function processTokens() public view returns (uint total) {
        uint x = 1;
        for (uint i = 0; i < tokens.length; i++) {
            // Condition always true: x=1, i≥0, so x+i≥1>0
            if (x + i > 0) {
                total += tokens[i];
            }
        }
    }
}
```

### Optimised (Removed Constant Check)
```solidity
contract OptimizedComparison {
    uint[] public tokens;
    
    function processTokens() public view returns (uint total) {
        uint x = 1;
        for (uint i = 0; i < tokens.length; i++) {
            // Redundant condition removed
            total += tokens[i];
        }
    }
}
```

## Gas Savings

Removing constant comparisons that always evaluate to the same value eliminates unnecessary conditional check operations in every loop iteration, reducing gas consumption without changing functionality.