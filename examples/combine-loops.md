# 22. Combine Multiple Loops into One

This transformation merges loops that traverse the same range into a single loop carrying all the bodies. The work of each body is unchanged; what disappears is the per-iteration overhead of the extra traversals, namely the counter increments, the comparisons and the reads of the bound.

## Example

### Original (Separate Loops)
```solidity
contract A {
    uint256[] public numbers;
    uint256 public sum;
    uint256 public product;
    uint256 public count;

    function processArray() public {
        sum = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }

        product = 1;
        for (uint256 i = 0; i < numbers.length; i++) {
            product *= numbers[i];
        }

        count = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] != 0) {
                count++;
            }
        }
    }
}
```

### Optimised (Combined Loop)
```solidity
contract Ao {
    uint256[] public numbers;
    uint256 public sum;
    uint256 public product;
    uint256 public count;

    function processArray() public {
        sum = 0;
        product = 1;
        count = 0;

        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
            product *= numbers[i];
            if (numbers[i] != 0) {
                count++;
            }
        }
    }
}
```

## Applicability

The bodies must be independent of one another: none may read a variable that another writes, since merging interleaves them. Here each body accumulates into its own variable.

The merge reorders the arithmetic, so an overflow is reached at a different point in the execution, but not on different inputs: each accumulation applies the same operations to the same values, so an operation that overflows in one version overflows in the other. A revert discards the whole transaction, so the point at which it is raised is not observable, and both versions fail on exactly the same inputs.

## Gas Savings

Three traversals become one. The saving is the loop overhead of the two traversals removed, proportional to the length of the array.
