// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract Ao - Optimized Boolean Packing
 * @notice This contract packs 32 boolean values into a single uint256
 * @dev Uses bitwise operations to store/retrieve boolean values
 * Gas Cost: Lower due to single storage slot usage
 */
contract aO {
    // State: Single uint256 to store all 32 booleans
    // Each boolean occupies 1 bit position
    uint256 private packedBooleans;
    
    // Bit masks for each boolean position
    uint256 constant MASK_1 = 1 << 0;
    uint256 constant MASK_2 = 1 << 1;
    uint256 constant MASK_3 = 1 << 2;
    uint256 constant MASK_4 = 1 << 3;
    uint256 constant MASK_5 = 1 << 4;
    uint256 constant MASK_6 = 1 << 5;
    uint256 constant MASK_7 = 1 << 6;
    uint256 constant MASK_8 = 1 << 7;
    uint256 constant MASK_9 = 1 << 8;
    uint256 constant MASK_10 = 1 << 9;
    uint256 constant MASK_11 = 1 << 10;
    uint256 constant MASK_12 = 1 << 11;
    uint256 constant MASK_13 = 1 << 12;
    uint256 constant MASK_14 = 1 << 13;
    uint256 constant MASK_15 = 1 << 14;
    uint256 constant MASK_16 = 1 << 15;
    uint256 constant MASK_17 = 1 << 16;
    uint256 constant MASK_18 = 1 << 17;
    uint256 constant MASK_19 = 1 << 18;
    uint256 constant MASK_20 = 1 << 19;
    uint256 constant MASK_21 = 1 << 20;
    uint256 constant MASK_22 = 1 << 21;
    uint256 constant MASK_23 = 1 << 22;
    uint256 constant MASK_24 = 1 << 23;
    uint256 constant MASK_25 = 1 << 24;
    uint256 constant MASK_26 = 1 << 25;
    uint256 constant MASK_27 = 1 << 26;
    uint256 constant MASK_28 = 1 << 27;
    uint256 constant MASK_29 = 1 << 28;
    uint256 constant MASK_30 = 1 << 29;
    uint256 constant MASK_31 = 1 << 30;
    uint256 constant MASK_32 = 1 << 31;
    
    /**
     * @notice Pack and store all 32 boolean values
     * @dev Uses bitwise operations to pack booleans into single uint256
     */
    function packBooleans(
        bool _b1, bool _b2, bool _b3, bool _b4,
        bool _b5, bool _b6, bool _b7, bool _b8,
        bool _b9, bool _b10, bool _b11, bool _b12,
        bool _b13, bool _b14, bool _b15, bool _b16,
        bool _b17, bool _b18, bool _b19, bool _b20,
        bool _b21, bool _b22, bool _b23, bool _b24,
        bool _b25, bool _b26, bool _b27, bool _b28,
        bool _b29, bool _b30, bool _b31, bool _b32
    ) public {
        uint256 packed = 0;
        
        if (_b1) packed |= MASK_1;
        if (_b2) packed |= MASK_2;
        if (_b3) packed |= MASK_3;
        if (_b4) packed |= MASK_4;
        if (_b5) packed |= MASK_5;
        if (_b6) packed |= MASK_6;
        if (_b7) packed |= MASK_7;
        if (_b8) packed |= MASK_8;
        if (_b9) packed |= MASK_9;
        if (_b10) packed |= MASK_10;
        if (_b11) packed |= MASK_11;
        if (_b12) packed |= MASK_12;
        if (_b13) packed |= MASK_13;
        if (_b14) packed |= MASK_14;
        if (_b15) packed |= MASK_15;
        if (_b16) packed |= MASK_16;
        if (_b17) packed |= MASK_17;
        if (_b18) packed |= MASK_18;
        if (_b19) packed |= MASK_19;
        if (_b20) packed |= MASK_20;
        if (_b21) packed |= MASK_21;
        if (_b22) packed |= MASK_22;
        if (_b23) packed |= MASK_23;
        if (_b24) packed |= MASK_24;
        if (_b25) packed |= MASK_25;
        if (_b26) packed |= MASK_26;
        if (_b27) packed |= MASK_27;
        if (_b28) packed |= MASK_28;
        if (_b29) packed |= MASK_29;
        if (_b30) packed |= MASK_30;
        if (_b31) packed |= MASK_31;
        if (_b32) packed |= MASK_32;
        
        packedBooleans = packed;
    }
    
    /**
     * @notice Unpack and retrieve all 32 boolean values
     * @dev Uses bitwise operations to extract booleans from uint256
     */
    function unpackBooleans() public view returns (
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool
    ) {
        return (
            (packedBooleans & MASK_1) != 0,
            (packedBooleans & MASK_2) != 0,
            (packedBooleans & MASK_3) != 0,
            (packedBooleans & MASK_4) != 0,
            (packedBooleans & MASK_5) != 0,
            (packedBooleans & MASK_6) != 0,
            (packedBooleans & MASK_7) != 0,
            (packedBooleans & MASK_8) != 0,
            (packedBooleans & MASK_9) != 0,
            (packedBooleans & MASK_10) != 0,
            (packedBooleans & MASK_11) != 0,
            (packedBooleans & MASK_12) != 0,
            (packedBooleans & MASK_13) != 0,
            (packedBooleans & MASK_14) != 0,
            (packedBooleans & MASK_15) != 0,
            (packedBooleans & MASK_16) != 0,
            (packedBooleans & MASK_17) != 0,
            (packedBooleans & MASK_18) != 0,
            (packedBooleans & MASK_19) != 0,
            (packedBooleans & MASK_20) != 0,
            (packedBooleans & MASK_21) != 0,
            (packedBooleans & MASK_22) != 0,
            (packedBooleans & MASK_23) != 0,
            (packedBooleans & MASK_24) != 0,
            (packedBooleans & MASK_25) != 0,
            (packedBooleans & MASK_26) != 0,
            (packedBooleans & MASK_27) != 0,
            (packedBooleans & MASK_28) != 0,
            (packedBooleans & MASK_29) != 0,
            (packedBooleans & MASK_30) != 0,
            (packedBooleans & MASK_31) != 0,
            (packedBooleans & MASK_32) != 0
        );
    }
    
    /**
     * @notice Set a specific boolean by index
     * @param index The index of the boolean (1-32)
     * @param value The boolean value to set
     */
    function setBoolean(uint8 index, bool value) public {
        require(index >= 1 && index <= 32, "Index out of bounds");
        
        uint256 mask = 1 << (index - 1);
        
        if (value) {
            // Set bit to 1
            packedBooleans |= mask;
        } else {
            // Set bit to 0
            packedBooleans &= ~mask;
        }
    }
    
    /**
     * @notice Get a specific boolean by index
     * @param index The index of the boolean (1-32)
     * @return The boolean value at the specified index
     */
    function getBoolean(uint8 index) public view returns (bool) {
        require(index >= 1 && index <= 32, "Index out of bounds");
        
        uint256 mask = 1 << (index - 1);
        return (packedBooleans & mask) != 0;
    }
    
    /**
     * @notice Get the raw packed value (for debugging/verification)
     * @return The uint256 containing all packed booleans
     */
    function getPackedValue() public view returns (uint256) {
        return packedBooleans;
    }
    
    /**
     * @notice Alternative setter using the same interface as Contract A
     * @dev Maps to packBooleans for interface compatibility
     */
    function setBooleans(
        bool _b1, bool _b2, bool _b3, bool _b4,
        bool _b5, bool _b6, bool _b7, bool _b8,
        bool _b9, bool _b10, bool _b11, bool _b12,
        bool _b13, bool _b14, bool _b15, bool _b16,
        bool _b17, bool _b18, bool _b19, bool _b20,
        bool _b21, bool _b22, bool _b23, bool _b24,
        bool _b25, bool _b26, bool _b27, bool _b28,
        bool _b29, bool _b30, bool _b31, bool _b32
    ) public {
        packBooleans(
            _b1, _b2, _b3, _b4, _b5, _b6, _b7, _b8,
            _b9, _b10, _b11, _b12, _b13, _b14, _b15, _b16,
            _b17, _b18, _b19, _b20, _b21, _b22, _b23, _b24,
            _b25, _b26, _b27, _b28, _b29, _b30, _b31, _b32
        );
    }
    
    /**
     * @notice Alternative getter using the same interface as Contract A
     * @dev Maps to unpackBooleans for interface compatibility
     */
    function getBooleans() public view returns (
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool
    ) {
        return unpackBooleans();
    }
}