# 7. Boolean Packing

This transformation packs multiple boolean variables into a single `uint256` storage slot using bitwise operations. Since Solidity stores each boolean as a full `uint8` (8 bits) in separate storage slots, packing up to 256 booleans into a single `uint256` can dramatically reduce storage costs. The gas savings from reduced storage operations outweigh the cost of bitwise packing/unpacking operations.

## Example

### Original (Unpacked Booleans)
```solidity
contract BooleansUnpacked {
    bool public isActive;
    bool public isPaused;
    bool public isVerified;
    bool public hasPermission;
    // Each boolean occupies a separate storage slot
    // 4 booleans = 4 storage slots = ~80,000 gas for SSTORE operations
}
```

### Optimised (Packed Booleans)
```solidity
contract BooleansPacked {
    uint256 private packedBooleans;
    
    // Bit masks for each boolean
    uint256 constant IS_ACTIVE = 1 << 0;      // 0x01
    uint256 constant IS_PAUSED = 1 << 1;      // 0x02
    uint256 constant IS_VERIFIED = 1 << 2;    // 0x04
    uint256 constant HAS_PERMISSION = 1 << 3; // 0x08
    
    // Set a boolean value
    function setFlag(uint256 mask, bool value) internal {
        if (value) {
            packedBooleans |= mask;  // Set bit to 1
        } else {
            packedBooleans &= ~mask; // Set bit to 0
        }
    }
    
    // Get a boolean value
    function getFlag(uint256 mask) internal view returns (bool) {
        return (packedBooleans & mask) != 0;
    }
    
    // Public interface
    function setActive(bool value) public {
        setFlag(IS_ACTIVE, value);
    }
    
    function isActive() public view returns (bool) {
        return getFlag(IS_ACTIVE);
    }
}
```

## Gas Savings

Packing multiple booleans into a single `uint256` reduces storage from n slots to 1 slot (for up to 256 booleans).