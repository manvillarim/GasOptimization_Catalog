# 15. Reduce Mathematical Expressions

This transformation simplifies complex mathematical expressions by applying algebraic rules and logical optimizations. Reducing the number of operations through factorization, applying De Morgan's laws, or eliminating redundant computations decreases the number of EVM opcodes executed, thereby reducing gas consumption.

## Example

### Original (Complex Expressions)
```solidity
contract ComplexMath {
    function calculateLogic(bool x, bool y) public pure returns (bool) {
        // Two NOT operations + one AND operation
        bool result = (!x) && (!y);
        return result;
    }
    
    function processValues(uint a, uint b, uint c) public pure returns (uint) {
        // Three multiplications + two additions
        uint result = (a * 2) + (b * 2) + (c * 2);
        return result;
    }
}
```

### Optimised (Reduced Expressions)
```solidity
contract ReducedMath {
    function calculateLogic(bool x, bool y) public pure returns (bool) {
        // De Morgan's law: one OR operation + one NOT operation
        bool result = !(x || y);
        return result;
    }
    
    function processValues(uint a, uint b, uint c) public pure returns (uint) {
        // Factored: two additions + one multiplication
        uint result = 2 * (a + b + c);
        return result;
    }
}
```

## Gas Savings

Reducing mathematical expressions through algebraic simplification and factorization decreases the number of EVM operations executed, lowering computational costs while maintaining identical results.