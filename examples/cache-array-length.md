# 25. Cache Array Length in Loops

This transformation reads the length of a storage array once, into a local variable, and uses that variable as the loop bound. The length of a storage array is itself a storage word, so evaluating it in the loop condition issues one SLOAD per iteration, whereas the local variable is held on the stack.

## Example

### Original (Uncached Array Length)
```solidity
contract A {
    uint256[] public numbers;

    function processNumbers() external {
        for (uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }

    function incrementAll() external {
        for (uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] + 1;
        }
    }
}
```

### Optimised (Cached Array Length)
```solidity
contract Ao {
    uint256[] public numbers;

    function processNumbers() external {
        uint256 length = numbers.length;
        for (uint256 i = 0; i < length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }

    function incrementAll() external {
        uint256 length = numbers.length;
        for (uint256 i = 0; i < length; i++) {
            numbers[i] = numbers[i] + 1;
        }
    }
}
```

## Applicability

The loop body must not change the length of the array. A `push` or a `pop` inside the loop makes the cached bound stale, and the two versions then iterate a different number of times. The bodies above only overwrite existing positions, so the bound is invariant.

## Gas Savings

The transformation replaces one SLOAD per iteration by a single SLOAD before the loop and stack reads thereafter. Only the first access to the slot is cold; the rest are warm reads of 100 gas each, which is what the rule removes on every iteration after the first.
