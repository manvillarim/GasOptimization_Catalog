# 4. Refactoring Loops with Repeated Computations

This transformation moves invariant computations out of loops. When the same expression is computed in every iteration but its result never changes, computing it once before the loop and storing the result in a local variable eliminates redundant operations. For Solidity 0.8.0+, a guard condition is added to prevent potential overflow when the array is empty.

## Example

### Original (Repeated Computation)
```solidity
contract RepeatedComputation {
    uint[] public tokens;
    uint public limit;
    uint public price;
    
    function distributeTokens() external {
        uint length = tokens.length;
        for (uint i = 0; i < length; i++) {
            // limit * price computed in every iteration
            tokens[i] += limit * price;
        }
    }
}
```

### Optimised (Hoisted Computation)
```solidity
contract OptimizedComputation {
    uint[] public tokens;
    uint public limit;
    uint public price;
    
    function distributeTokens() external {
        uint length = tokens.length;
        if (length > 0) {  // Guard prevents overflow when length = 0
            uint amount = limit * price;  // Computed once
            for (uint i = 0; i < length; i++) {
                tokens[i] += amount;
            }
        }
    }
}
```

## Gas Savings

Moving loop-invariant computations outside the loop reduces gas consumption by eliminating redundant calculations. The guard condition ensures behavioural equivalence in Solidity 0.8.0+, where the original version would not enter the loop (thus not computing `limit * price`) if `length` is zero, while the optimised version would compute it before checking length without the guard.