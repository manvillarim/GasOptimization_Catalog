# 5. Struct Packing

This transformation reorders struct member declarations to pack multiple smaller variables into single 256-bit storage slots. The EVM allocates storage in 32-byte slots, and struct members smaller than 256 bits can share a slot if declared consecutively. Proper ordering within structs minimizes storage slot usage, reducing gas costs for struct creation and access.

## Example

### Original (Unpacked Struct)
```solidity
contract UnpackedStruct {
    struct Data {
        uint256 a;  // Slot 0 (256 bits)
        bool b;     // Slot 1 (8 bits used, 248 bits wasted)
        uint8 c;    // Slot 2 (8 bits used, 248 bits wasted)
    }
    // Total: 3 storage slots per Data instance
    
    Data public data;
}
```

### Optimised (Packed Struct)
```solidity
contract PackedStruct {
    struct Data {
        uint8 c;    // Slot 0 (8 bits)
        bool b;     // Slot 0 (8 bits) - shares slot with 'c'
        uint256 a;  // Slot 1 (256 bits)
    }
    // Total: 2 storage slots per Data instance
    
    Data public data;
}
```

## Gas Savings

Packing struct members reduces the number of storage slots per struct instance, lowering gas costs for struct initialization and for functions that access multiple packed members (single SLOAD instead of multiple).