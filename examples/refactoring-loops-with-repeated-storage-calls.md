# 2. Refactoring Loops with Repeated Storage Calls

This transformation reads a storage variable into a local variable before a loop that accumulates into it, and writes the result back once the loop is over. The intermediate values never reach storage.

## Example

### Original (Storage Updated on Each Iteration)
```solidity
contract A {
    uint256 public total;
    uint256[] public tokens;

    function sumTokens() public {
        for (uint256 i = 0; i < tokens.length; i++) {
            total += tokens[i];
        }
    }
}
```

### Optimised (Accumulated in a Local)
```solidity
contract Ao {
    uint256 public total;
    uint256[] public tokens;

    function sumTokens() public {
        uint256 local = total;
        for (uint256 i = 0; i < tokens.length; i++) {
            local += tokens[i];
        }
        total = local;
    }
}
```

## Applicability

Nothing between the initial read and the write-back may observe or modify `total`. The body above touches no other state, so the condition holds; it fails as soon as the loop performs an external call, since the callee could read the variable and see a value the original would not have shown it, or write it and have that write discarded by the write-back.

The additions are performed on the same values in the same order, so an overflow occurs at the same iteration in both versions and both revert.

## Gas Savings

One storage read and one storage write per iteration become a single read before the loop and a single write after it. The saving grows linearly with the trip count and is the largest of the loop rules in this catalogue, storage being the dominant cost of such a body.
