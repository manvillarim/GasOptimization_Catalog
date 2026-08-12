# 4. Refactoring Loops with Repeated Computations

This transformation moves a computation that does not change between iterations out of the loop, into a local variable read by the body.

## Example

### Original (Computation Repeated)
```solidity
contract A {
    uint256[] public tokens;
    uint256 public limit;
    uint256 public price;

    function distributeTokens() external {
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += limit * price;
        }
    }
}
```

### Optimised (Computation Hoisted)
```solidity
contract Ao {
    uint256[] public tokens;
    uint256 public limit;
    uint256 public price;

    function distributeTokens() external {
        uint256 length = tokens.length;
        if (length > 0) {
            uint256 amount = limit * price;
            for (uint256 i = 0; i < length; i++) {
                tokens[i] += amount;
            }
        }
    }
}
```

## Applicability

The guard `length > 0` is what makes the transformation sound from Solidity 0.8.0 on, and the published form of this rule omits it. Hoisting moves `limit * price` to a point that is reached even when the loop body never runs. On an empty array the original evaluates nothing, while the unguarded rewrite evaluates the product, and a product that overflows makes it revert where the original returns. Our framework detected the rule in its published form for exactly this reason. Before 0.8.0 the multiplication wrapped instead of reverting, and the guard was unnecessary.

The hoisted expression must also be invariant in fact: neither `limit` nor `price` may be written by the body, and the body may not call out to code that could write them.

## Gas Savings

One multiplication and the two storage reads that feed it are removed from every iteration and paid once. The saving is proportional to the trip count, and the guard costs one comparison.
