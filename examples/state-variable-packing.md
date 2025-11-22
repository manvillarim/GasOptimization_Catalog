# 6. State Variable Packing

This transformation reorders state variable declarations to pack multiple smaller variables into single 256-bit storage slots. The EVM allocates storage in 32-byte (256-bit) slots, and variables smaller than 256 bits can share a slot if declared consecutively. Proper ordering minimizes the number of storage slots used, reducing both deployment and runtime gas costs.

## Example

### Original (Unpacked State Variables)
```solidity
contract UnpackedVariables {
    uint128 a;  // Slot 0 (128 bits used, 128 bits wasted)
    uint256 b;  // Slot 1 (256 bits used)
    uint128 c;  // Slot 2 (128 bits used, 128 bits wasted)
    // Total: 3 storage slots
}
```

### Optimised (Packed State Variables)
```solidity
contract PackedVariables {
    uint128 a;  // Slot 0 (128 bits)
    uint128 c;  // Slot 0 (128 bits) - shares slot with 'a'
    uint256 b;  // Slot 1 (256 bits)
    // Total: 2 storage slots
}
```

## Gas Savings

Packing state variables reduces the number of storage slots used, lowering gas costs for deployment (fewer SSTORE operations during construction) and for functions that access multiple packed variables simultaneously (single SLOAD instead of multiple).