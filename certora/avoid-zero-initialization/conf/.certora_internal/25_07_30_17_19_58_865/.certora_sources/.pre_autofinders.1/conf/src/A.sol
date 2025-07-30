// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract A - Explicit Zero Initialization
 * @dev This contract demonstrates explicit zero initialization which is redundant
 * and consumes unnecessary gas since Solidity automatically initializes variables
 * with their default zero values.
 */
contract A {
    // State variables with explicit zero initialization (unnecessary)
    uint256 public balance = 0;           // Explicitly set to 0
    uint32 public userCount = 0;          // Explicitly set to 0
    int256 public temperature = 0;        // Explicitly set to 0
    bool public isActive = false;         // Explicitly set to false
    bool public isPaused = false;         // Explicitly set to false
    address public owner = address(0);    // Explicitly set to zero address
    address public admin = address(0);    // Explicitly set to zero address
    bytes32 public dataHash = 0x0;        // Explicitly set to zero bytes
    
    // Mapping with explicit zero values (unnecessary)
    mapping(address => uint256) public balances;
    
    /**
     * @dev Function demonstrating explicit zero initialization in local variables
     * This approach wastes gas and is redundant
     */
    function processData() public view returns (uint256, bool, address) {
        // Local variables with explicit zero initialization (unnecessary)
        uint256 localCounter = 0;         // Explicitly set to 0
        uint256 result = 0;               // Explicitly set to 0
        bool success = false;             // Explicitly set to false
        address targetAddress = address(0); // Explicitly set to zero address
        
        // Some processing logic
        for (uint256 i = 0; i < 10; i++) {  // Explicit i = 0 initialization
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
     * @dev Function to reset values with explicit zero assignments
     * This demonstrates wasteful explicit zero assignments
     */
    function resetAllValues() public {
        // Explicit zero assignments (unnecessary gas consumption)
        balance = 0;
        userCount = 0;
        temperature = 0;
        isActive = false;
        isPaused = false;
        owner = address(0);
        admin = address(0);
        dataHash = 0x0;
    }
    
    /**
     * @dev Function with explicit zero initialization in loops and conditions
     */
    function calculateSum(uint256[] memory numbers) public pure returns (uint256) {
        uint256 sum = 0;              // Explicit zero initialization
        uint256 evenCount = 0;        // Explicit zero initialization
        bool hasEvenNumbers = false;  // Explicit zero initialization
        
        for (uint256 index = 0; index < numbers.length; index++) {  // Explicit index = 0
            sum += numbers[index];
            
            if (numbers[index] % 2 == 0) {
                evenCount += 1;
                hasEvenNumbers = true;
            }
        }
        
        return hasEvenNumbers ? sum + evenCount : sum;
    }
    
    /**
     * @dev Struct with explicit zero initialization
     */
    struct UserData {
        uint256 id;
        bool active;
        address wallet;
    }
    
    /**
     * @dev Function creating struct with explicit zero values
     */
    function createUser() public pure returns (UserData memory) {
        // Explicit zero initialization of struct fields (unnecessary)
        UserData memory newUser = UserData({
            id: 0,              // Explicitly set to 0
            active: false,      // Explicitly set to false
            wallet: address(0)  // Explicitly set to zero address
        });
        
        return newUser;
    }
}