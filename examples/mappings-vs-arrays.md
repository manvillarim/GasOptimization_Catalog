# 27. Use Mappings Instead of Arrays for Data Lists

This transformation replaces a dynamic array by a mapping from index to element, together with an explicit counter that takes the place of the length. The array's own length slot and the bookkeeping that maintains it disappear.

## Example

### Original (Dynamic Array)
```solidity
contract A {
    uint256[] public numbers;

    function addNumber(uint256 number) public {
        numbers.push(number);
    }

    function getNumber(uint256 index) public view returns (uint256) {
        require(index < numbers.length, "Index out of bounds");
        return numbers[index];
    }
}
```

### Optimised (Mapping with Explicit Counter)
```solidity
contract Ao {
    mapping(uint256 => uint256) public numbers;
    uint256 public size;

    function addNumber(uint256 number) public {
        numbers[size] = number;
        unchecked { size++; }
    }

    function getNumber(uint256 index) public view returns (uint256) {
        require(index < size, "Index out of bounds");
        return numbers[index];
    }
}
```

## Applicability

The `unchecked` block is required from Solidity 0.8.0 on. `push()` increments the length without a checked-arithmetic guard, so it wraps when the length is at its maximum, whereas a plain `size++` is checked and raises a panic in that state. Without `unchecked` the two contracts disagree on exactly that input, which is how our framework detected the published form of this rule as outdated. Before 0.8.0 both wrapped, and the rule was sound as originally stated.

The automatic getters do not agree either. `numbers(i)` on the array reverts for an index beyond the length, while on the mapping it returns zero for any index. Keeping the mapping `public` therefore exposes a difference; the transformation preserves the interface only if the mapping is made private and the reads go through `getNumber`, which restores the bounds check.

## Gas Savings

The saving is concentrated in deployment, where the array's length handling is replaced by a plain counter. Insertion cost is unchanged in practice, being dominated by one cold `SSTORE` whose price does not depend on the underlying structure.
