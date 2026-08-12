# 8. Use Fixed-Size Arrays Instead of Dynamic Arrays

This transformation replaces a dynamic array by a fixed-size array of a bound known at compile time, together with an explicit counter. A dynamic array keeps its length in a storage slot and computes the position of its elements from the hash of that slot; a fixed-size array is laid out at consecutive slots known statically, and `push` disappears together with the length update it performs.

## Example

### Original (Dynamic Array)
```solidity
contract A {
    uint256[] private items;

    function add(uint256 value) external {
        items.push(value);
    }

    function get(uint256 index) external view returns (uint256) {
        require(index < items.length, "Index out of bounds");
        return items[index];
    }

    function length() external view returns (uint256) {
        return items.length;
    }
}
```

### Optimised (Fixed-Size Array)
```solidity
contract Ao {
    uint256[100] private items;
    uint256 private count;

    function add(uint256 value) external {
        require(count < 100, "Capacity exceeded");
        items[count] = value;
        count++;
    }

    function get(uint256 index) external view returns (uint256) {
        require(index < count, "Index out of bounds");
        return items[index];
    }

    function length() external view returns (uint256) {
        return count;
    }
}
```

## Applicability

The bound must hold. The two contracts agree on every execution in which fewer than 100 elements are stored; on the hundred-and-first `add` the original grows and the rewrite reverts. The transformation therefore carries the condition that the number of elements is bounded by the chosen capacity, and that condition has to be established outside the contract, since it is not enforced by the original.

The counter must also be reproduced faithfully. `count` is what `items.length` was, so it has to be updated wherever the original would have grown or shrunk the array, and `get` must compare against it rather than against the capacity, or reads of positions that were never written would return zero instead of reverting.

The state layouts differ, so the coupling invariant relates `items` and `count` of the rewrite to the elements and the length of the original, and not slot to slot.

## Gas Savings

`add` no longer updates the length slot, and the position of every element is a static offset rather than the hash of the length slot. The saving is per operation and does not grow with the size of the array.
