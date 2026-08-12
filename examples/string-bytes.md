# 29. Use Bytes Instead of Strings

This transformation replaces a `string` by a `bytes` where the value is not treated as text.

The usual justification for it does not hold. Solidity does not encode, validate or otherwise interpret the contents of a `string`: the type is a dynamic byte array with a different name, laid out in storage exactly as `bytes` is, and no UTF-8 handling is emitted anywhere. Compiled with solc 0.8.26 and the optimiser at 200 runs, the pair below produces runtime code of the same size, 586 bytes each, differing only in the constants that encode the signatures.

What the transformation does buy is direct access. `string` offers neither `.length` nor indexing, so any code that needs them has to write `bytes(data)`, and that conversion is free but obscures the intent. Choosing `bytes` for data that is never read as text removes the conversion from the source.

## Example

### Original (Using String)
```solidity
contract A {
    string private data;

    function setData(string calldata newData) external {
        data = newData;
    }

    function getData() external view returns (string memory) {
        return data;
    }

    function length() external view returns (uint256) {
        return bytes(data).length;
    }
}
```

### Optimised (Using Bytes)
```solidity
contract Ao {
    bytes private data;

    function setData(bytes calldata newData) external {
        data = newData;
    }

    function getData() external view returns (bytes memory) {
        return data;
    }

    function length() external view returns (uint256) {
        return data.length;
    }
}
```

## Applicability

This rule changes the interface. `setData(string)` and `setData(bytes)` are different signatures with different selectors, `0x47064d6a` against `0xab62f0e1`, and `getData` changes its declared return type. A client of the original does not reach the rewritten contract, so the transformation is admissible only when every caller is updated with it, and it is not an instance of the equivalence used elsewhere in this catalogue, where a call is compared against the same call.

The choice is also semantic. `string` documents that the value is text and is what a consumer off chain will expect to decode as such; `bytes` documents the opposite. The rule applies where that documentation was wrong to begin with.

## Gas Savings

None from the storage encoding, which is the same for both types, and none measurable from the access, the conversion `bytes(data)` costing nothing at runtime.
