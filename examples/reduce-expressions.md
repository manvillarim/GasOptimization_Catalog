# 16. Reduce mathematical expressions

This transformation simplifies complex mathematical expressions by applying algebraic rules and logical optimizations. By reducing the number of operations and factoring expressions, we can significantly decrease gas consumption while maintaining the same functionality.

## Example

### Complex Mathematical Expression
```solidity
contract ComplexMath {
    function calculateResult(bool x, bool y) public pure returns(bool) {
        // Complex expression: !x && !y
        bool result = (!x) && (!y);
        return result;
    }
    
    function processValues(uint a, uint b, uint c) public pure returns(uint) {
        // Multiple redundant operations
        uint result = (a * 2) + (b * 2) + (c * 2);
        return result;
    }
}
```
### Optimized Reduced Expression

```solidity
contract ReducedMath {
    function calculateResult(bool x, bool y) public pure returns(bool) {
        // Reduced expression using De Morgan's law: !(x || y)
        bool result = !(x || y);
        return result;
    }
    
    function processValues(uint a, uint b, uint c) public pure returns(uint) {
        // Factored expression: 2 * (a + b + c)
        uint result = 2 * (a + b + c);
        return result;
    }
}
```