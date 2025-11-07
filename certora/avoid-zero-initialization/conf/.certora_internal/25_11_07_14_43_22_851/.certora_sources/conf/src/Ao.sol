// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract Ao - Optimized Default Initialization
 * @dev This contract demonstrates optimized initialization by relying on Solidity's
 * automatic default initialization, which saves gas and reduces code redundancy.
 * All variables are automatically initialized to their zero values without explicit assignment.
 */
contract Ao {
    // State variables with default initialization (gas-efficient)
    uint256 public balance;           // Automatically initialized to 0
    uint32 public userCount;          // Automatically initialized to 0
    int256 public temperature;        // Automatically initialized to 0
    bool public isActive;             // Automatically initialized to false
    bool public isPaused;             // Automatically initialized to false
    address public owner;             // Automatically initialized to address(0)
    address public admin;             // Automatically initialized to address(0)
    bytes32 public dataHash;          // Automatically initialized to 0x0
    
    // Mapping automatically initializes all values to zero
    mapping(address => uint256) public balances;
    
    /**
     * @dev Function demonstrating default initialization in local variables
     * This approach is gas-efficient and cleaner
     */
    function processData() public view returns (uint256, bool, address) {
        // Local variables with default initialization (gas-efficient)
        uint256 localCounter;         // Automatically initialized to 0
        uint256 result;               // Automatically initialized to 0
        bool success;                 // Automatically initialized to false
        address targetAddress;        // Automatically initialized to address(0)
        
        // Some processing logic
        for (uint256 i; i < 10; i++) {  // i automatically initialized to 0
            localCounter += i;
        }
        
        // Conditional logic
        if (localCounter > 5) {
            success = true;
            result = localCounter * 2;
            targetAddress = msg.sender;
        }
        
        return (result, success, targetAddress);
    }
    
    /**
     * @dev Function to reset values using default initialization approach
     * Only explicit assignments when setting to non-zero values
     */
    function resetAllValues() public {
        // Only reset to zero when necessary, or use delete for gas efficiency
        delete balance;        // More gas-efficient than setting to 0
        delete userCount;      // More gas-efficient than setting to 0
        delete temperature;    // More gas-efficient than setting to 0
        delete isActive;       // More gas-efficient than setting to false
        delete isPaused;       // More gas-efficient than setting to false
        delete owner;          // More gas-efficient than setting to address(0)
        delete admin;          // More gas-efficient than setting to address(0)
        delete dataHash;       // More gas-efficient than setting to 0x0
    }
    
    /**
     * @dev Function with default initialization in loops and conditions
     */
    function calculateSum(uint256[] memory numbers) public pure returns (uint256) {
        uint256 sum;              // Automatically initialized to 0
        uint256 evenCount;        // Automatically initialized to 0
        bool hasEvenNumbers;      // Automatically initialized to false
        
        for (uint256 index; index < numbers.length; index++) {  // index automatically initialized to 0
            sum += numbers[index];
            
            if (numbers[index] % 2 == 0) {
                evenCount += 1;
                hasEvenNumbers = true;
            }
        }
        
        return hasEvenNumbers ? sum + evenCount : sum;
    }
    
    /**
     * @dev Struct definition (fields automatically initialize to zero values)
     */
    struct UserData {
        uint256 id;      // Automatically initialized to 0
        bool active;     // Automatically initialized to false
        address wallet;  // Automatically initialized to address(0)
    }
    
    /**
     * @dev Function creating struct with default initialization
     */
    function createUser() public pure returns (UserData memory) {
        // Default initialization of struct (all fields automatically zero)
        UserData memory newUser;  // All fields automatically initialized to zero values
        
        return newUser;
    }
    
    /**
     * @dev Alternative struct creation with memory allocation
     * Still relies on default initialization for gas efficiency
     */
    function createEmptyUser() public pure returns (UserData memory) {
        // This creates a struct with all default zero values
        return UserData(0, false, address(0)); // Only when you need to be explicit for readability
    }
    
    /**
     * @dev Function demonstrating efficient array processing
     */
    function processArray(uint256[] memory data) public pure returns (uint256[] memory) {
        uint256[] memory results = new uint256[](data.length); // Array elements automatically initialized to 0
        
        for (uint256 i; i < data.length; i++) {  // i automatically initialized to 0
            // Only assign when value is non-zero
            if (data[i] > 0) {
                results[i] = data[i] * 2;
            }
            // No need to explicitly set results[i] = 0 for zero cases
        }
        
        return results;
    }
}