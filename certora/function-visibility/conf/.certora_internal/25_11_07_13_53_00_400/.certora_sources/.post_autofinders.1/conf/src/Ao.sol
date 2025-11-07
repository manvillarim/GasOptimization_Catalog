// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Optimized Function Visibility
 * This contract demonstrates efficient use of function visibility modifiers
 * resulting in lower gas costs and smaller bytecode size
 */
contract Ao {
    address public owner = 0x742D35cC6634c0532925a3b8D0B9B9dC19FAbE07;
    uint private totalTokens;
    uint private maxSupply = 1000000;
    mapping(address => uint) private balances;
    mapping(address => bool) private isAuthorized;
    
    // External function for external calls only - gas optimized
    function setOwner(address newOwner) external {
        require(msg.sender == owner, "Not authorized");
        owner = newOwner;
    }
    
    // Internal function for internal use - no call overhead
    function getTotalTokens() internal view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) }
        return totalTokens;
    }
    
    // Internal function for internal use - efficient
    function getMaxSupply() internal view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0004, 0) }
        return maxSupply;
    }
    
    // Internal function for internal use - optimal
    function isUserAuthorized(address user) internal view returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c6000, user) }
        return isAuthorized[user];
    }
    
    // Internal function for internal operations - no external call overhead
    function updateBalance(address user, uint amount) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d6001, amount) }
        balances[user] = amount;
    }
    
    // External function with optimized internal calls
    function mintTokens(address recipient, uint amount) external {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(recipient), "User not authorized"); // Direct internal call
        
        uint currentTotal = getTotalTokens();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,currentTotal)} // Direct internal call
        uint maxAllowed = getMaxSupply();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,maxAllowed)}    // Direct internal call
        
        require(currentTotal + amount <= maxAllowed, "Exceeds max supply");
        
        totalTokens = currentTotal + amount;
        updateBalance(recipient, balances[recipient] + amount); // Direct internal call
    }
    
    // External function with optimized internal operations
    function burnTokens(address user, uint amount) external {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(user), "User not authorized"); // Direct internal call
        
        uint currentBalance = balances[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,currentBalance)}
        require(currentBalance >= amount, "Insufficient balance");
        
        updateBalance(user, currentBalance - amount); // Direct internal call
        totalTokens -= amount;                        // Direct state modification
    }
    
    // External function with optimized internal operations
    function transferTokens(address from, address to, uint amount) external {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(from) && isUserAuthorized(to), "Users not authorized");
        
        uint fromBalance = balances[from];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,fromBalance)}
        require(fromBalance >= amount, "Insufficient balance");
        
        updateBalance(from, fromBalance - amount);    // Direct internal call
        updateBalance(to, balances[to] + amount);    // Direct internal call
    }
    
    // External function for external calls only - optimal visibility
    function authorizeUser(address user) external {
        require(msg.sender == owner, "Not authorized");
        isAuthorized[user] = true;
    }
    
    // External view function - optimal for external queries
    function getBalance(address user) external view returns(uint) {
        return balances[user];
    }
    
    // External view function to access internal data when needed externally
    function getTotalSupply() external view returns(uint) {
        return getTotalTokens(); // Internal call to internal function
    }
}