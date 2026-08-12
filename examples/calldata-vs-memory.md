# 10. Use Calldata Instead of Memory for Function Parameters

This transformation changes the data location of a reference-type parameter from `memory` to `calldata`. A `memory` parameter is copied out of the calldata into memory when the function is entered, which costs gas proportional to the size of the argument and expands the memory the transaction pays for. A `calldata` parameter is read in place.

## Example

### Original (Memory Parameters)
```solidity
contract A {
    function processArray(uint256[] memory numbers) external pure returns (uint256 sum) {
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
    }

    function firstOf(uint256[] memory numbers) external pure returns (uint256) {
        require(numbers.length > 0, "Empty array");
        return numbers[0];
    }
}
```

### Optimised (Calldata Parameters)
```solidity
contract Ao {
    function processArray(uint256[] calldata numbers) external pure returns (uint256 sum) {
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
    }

    function firstOf(uint256[] calldata numbers) external pure returns (uint256) {
        require(numbers.length > 0, "Empty array");
        return numbers[0];
    }
}
```

The data location is not part of the function signature, so both contracts expose the same selectors and the transformation is invisible to a caller.

## Applicability

`calldata` is read-only. The transformation applies only where the body never assigns to the parameter or to any of its elements, and never passes it where a `memory` reference is required. A body that mutates its argument must keep the copy, whether the parameter is declared `memory` or an explicit copy is made from a `calldata` parameter.

The location is available for parameters of `public` and `internal` functions as well, since Solidity 0.6.9; the restriction to `external` functions that older sources state no longer holds.

## Gas Savings

The saving is the copy itself: the calldata-to-memory transfer and the memory expansion it causes, both proportional to the length of the argument. It is largest for functions that take large arrays and read only part of them.
