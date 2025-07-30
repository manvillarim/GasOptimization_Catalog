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
    function processData() public view returns (uint256, bool, address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070004, 0) }
        // Local variables with default initialization (gas-efficient)
        uint256 localCounter;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,localCounter)}         // Automatically initialized to 0
        uint256 result;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,result)}               // Automatically initialized to 0
        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,success)}                 // Automatically initialized to false
        address targetAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,targetAddress)}        // Automatically initialized to address(0)
        
        // Some processing logic
        for (uint256 i; i < 10; i++) {  // i automatically initialized to 0
            localCounter += i;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,localCounter)}
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
    function resetAllValues() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060004, 0) }
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
    function calculateSum(uint256[] memory numbers) public pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, numbers) }
        uint256 sum;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,sum)}              // Automatically initialized to 0
        uint256 evenCount;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,evenCount)}        // Automatically initialized to 0
        bool hasEvenNumbers;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,hasEvenNumbers)}      // Automatically initialized to false
        
        for (uint256 index; index < numbers.length; index++) {  // index automatically initialized to 0
            sum += numbers[index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,sum)}
            
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
    function createUser() public pure returns (UserData memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090004, 0) }
        // Default initialization of struct (all fields automatically zero)
        UserData memory newUser;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010008,0)}  // All fields automatically initialized to zero values
        
        return newUser;
    }
    
    /**
     * @dev Alternative struct creation with memory allocation
     * Still relies on default initialization for gas efficiency
     */
    function createEmptyUser() public pure returns (UserData memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080004, 0) }
        // This creates a struct with all default zero values
        return UserData(0, false, address(0)); // Only when you need to be explicit for readability
    }
    
    /**
     * @dev Function demonstrating efficient array processing
     */
    function processArray(uint256[] memory data) public pure returns (uint256[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046000, data) }
        uint256[] memory results = new uint256[](data.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010009,0)} // Array elements automatically initialized to 0
        
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