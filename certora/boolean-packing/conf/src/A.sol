// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract A - Traditional Boolean Storage
 * @notice This contract stores 32 boolean variables separately
 * @dev Each boolean occupies a full storage slot (256 bits)
 * Gas Cost: Higher due to multiple storage slots
 */
contract A {
    // State: 32 independent boolean variables
    // Each occupies 1 storage slot (256 bits)
    bool public b1;
    bool public b2;
    bool public b3;
    bool public b4;
    bool public b5;
    bool public b6;
    bool public b7;
    bool public b8;
    bool public b9;
    bool public b10;
    bool public b11;
    bool public b12;
    bool public b13;
    bool public b14;
    bool public b15;
    bool public b16;
    bool public b17;
    bool public b18;
    bool public b19;
    bool public b20;
    bool public b21;
    bool public b22;
    bool public b23;
    bool public b24;
    bool public b25;
    bool public b26;
    bool public b27;
    bool public b28;
    bool public b29;
    bool public b30;
    bool public b31;
    bool public b32;
    
    /**
     * @notice Set all boolean values
     * @dev Writes to 32 different storage slots
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
        b1 = _b1;
        b2 = _b2;
        b3 = _b3;
        b4 = _b4;
        b5 = _b5;
        b6 = _b6;
        b7 = _b7;
        b8 = _b8;
        b9 = _b9;
        b10 = _b10;
        b11 = _b11;
        b12 = _b12;
        b13 = _b13;
        b14 = _b14;
        b15 = _b15;
        b16 = _b16;
        b17 = _b17;
        b18 = _b18;
        b19 = _b19;
        b20 = _b20;
        b21 = _b21;
        b22 = _b22;
        b23 = _b23;
        b24 = _b24;
        b25 = _b25;
        b26 = _b26;
        b27 = _b27;
        b28 = _b28;
        b29 = _b29;
        b30 = _b30;
        b31 = _b31;
        b32 = _b32;
    }
    
    /**
     * @notice Get all boolean values
     * @dev Reads from 32 different storage slots
     */
    function getBooleans() public view returns (
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool,
        bool, bool, bool, bool, bool, bool, bool, bool
    ) {
        return (
            b1, b2, b3, b4, b5, b6, b7, b8,
            b9, b10, b11, b12, b13, b14, b15, b16,
            b17, b18, b19, b20, b21, b22, b23, b24,
            b25, b26, b27, b28, b29, b30, b31, b32
        );
    }
    
    /**
     * @notice Set a specific boolean by index
     * @param index The index of the boolean (1-32)
     * @param value The boolean value to set
     */
    function setBoolean(uint8 index, bool value) public {
        require(index >= 1 && index <= 32, "Index out of bounds");
        
        if (index == 1) b1 = value;
        else if (index == 2) b2 = value;
        else if (index == 3) b3 = value;
        else if (index == 4) b4 = value;
        else if (index == 5) b5 = value;
        else if (index == 6) b6 = value;
        else if (index == 7) b7 = value;
        else if (index == 8) b8 = value;
        else if (index == 9) b9 = value;
        else if (index == 10) b10 = value;
        else if (index == 11) b11 = value;
        else if (index == 12) b12 = value;
        else if (index == 13) b13 = value;
        else if (index == 14) b14 = value;
        else if (index == 15) b15 = value;
        else if (index == 16) b16 = value;
        else if (index == 17) b17 = value;
        else if (index == 18) b18 = value;
        else if (index == 19) b19 = value;
        else if (index == 20) b20 = value;
        else if (index == 21) b21 = value;
        else if (index == 22) b22 = value;
        else if (index == 23) b23 = value;
        else if (index == 24) b24 = value;
        else if (index == 25) b25 = value;
        else if (index == 26) b26 = value;
        else if (index == 27) b27 = value;
        else if (index == 28) b28 = value;
        else if (index == 29) b29 = value;
        else if (index == 30) b30 = value;
        else if (index == 31) b31 = value;
        else if (index == 32) b32 = value;
    }
    
    /**
     * @notice Get a specific boolean by index
     * @param index The index of the boolean (1-32)
     * @return The boolean value at the specified index
     */
    function getBoolean(uint8 index) public view returns (bool) {
        require(index >= 1 && index <= 32, "Index out of bounds");
        
        if (index == 1) return b1;
        else if (index == 2) return b2;
        else if (index == 3) return b3;
        else if (index == 4) return b4;
        else if (index == 5) return b5;
        else if (index == 6) return b6;
        else if (index == 7) return b7;
        else if (index == 8) return b8;
        else if (index == 9) return b9;
        else if (index == 10) return b10;
        else if (index == 11) return b11;
        else if (index == 12) return b12;
        else if (index == 13) return b13;
        else if (index == 14) return b14;
        else if (index == 15) return b15;
        else if (index == 16) return b16;
        else if (index == 17) return b17;
        else if (index == 18) return b18;
        else if (index == 19) return b19;
        else if (index == 20) return b20;
        else if (index == 21) return b21;
        else if (index == 22) return b22;
        else if (index == 23) return b23;
        else if (index == 24) return b24;
        else if (index == 25) return b25;
        else if (index == 26) return b26;
        else if (index == 27) return b27;
        else if (index == 28) return b28;
        else if (index == 29) return b29;
        else if (index == 30) return b30;
        else if (index == 31) return b31;
        else if (index == 32) return b32;
        
        return false; // Default (unreachable)
    }
}