# 23. Cache Storage Variables

This transformation reads a storage variable into a local variable before a loop, performs the accumulation on the local, and writes the result back once. A storage read costs 2,100 gas cold and 100 gas warm, and a storage write costs at least 100 gas, whereas the local variable is held on the stack.

## Example

### Original (Repeated Storage Access)
```solidity
contract A {
    uint256 public total;
    uint256 public count;
    uint256[] public numbers;

    function processNumbers() public {
        for (uint256 i = 0; i < numbers.length; i++) {
            total += numbers[i];
            count++;
        }
    }
}
```

### Optimised (Cached Storage Variables)
```solidity
contract Ao {
    uint256 public total;
    uint256 public count;
    uint256[] public numbers;

    function processNumbers() public {
        uint256 tempTotal = total;
        uint256 tempCount = count;

        for (uint256 i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i];
            tempCount++;
        }

        total = tempTotal;
        count = tempCount;
    }
}
```

## Applicability

Between the initial read and the write-back, nothing may observe or modify the cached variables. The loop body above touches only local state, so the condition holds. It fails as soon as the body performs an external call, since the callee may read `total` — obtaining the stale value — or reenter and write it, in which case the write-back would discard that update.

The accumulation itself is unaffected: the additions occur in the same order on the same values, so an overflow occurs at the same iteration in both versions and both revert.

## Gas Savings

The transformation replaces one storage read and one storage write per iteration, for each cached variable, by a single read before the loop and a single write after it. The saving grows linearly with the trip count.
