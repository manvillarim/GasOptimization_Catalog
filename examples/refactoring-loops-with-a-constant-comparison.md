# 3. Refactoring Loops with a Constant Comparison

This transformation removes a conditional inside a loop whose value is the same on every iteration. The check consumes gas at each pass and decides nothing.

## Example

### Original (Constant Comparison)
```solidity
contract A {
    uint256[] public tokens;

    function processTokens() public view returns (uint256 total) {
        uint256 x = 1;
        for (uint256 i = 0; i < tokens.length; i++) {
            if (x + i > 0) {
                total += tokens[i];
            }
        }
    }
}
```

### Optimised (Comparison Removed)
```solidity
contract Ao {
    uint256[] public tokens;

    function processTokens() public view returns (uint256 total) {
        for (uint256 i = 0; i < tokens.length; i++) {
            total += tokens[i];
        }
    }
}
```

## Applicability

The condition has to be constant over the whole range the loop covers, and this has to be established from the code rather than from the values the contract happens to hold. Here `x` is `1` and `i` is non-negative, so `x + i > 0` holds at every iteration, and `x` is a local that nothing in the body assigns.

Removing the condition also removes the evaluation of its operands, which is only sound when that evaluation cannot itself fail. `x + i` is checked arithmetic and would panic on overflow; it cannot overflow here because `i` is bounded by the length of the array, but a guard containing a division, an array access or a call must be examined before it is dropped.

## Gas Savings

The comparison and its operand evaluation disappear from every iteration, so the saving is proportional to the trip count.
