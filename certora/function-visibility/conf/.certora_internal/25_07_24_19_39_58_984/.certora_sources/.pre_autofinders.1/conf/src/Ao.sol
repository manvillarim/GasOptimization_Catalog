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
    function getTotalTokens() internal view returns(uint) {
        return totalTokens;
    }
    
    // Internal function for internal use - efficient
    function getMaxSupply() internal view returns(uint) {
        return maxSupply;
    }
    
    // Internal function for internal use - optimal
    function isUserAuthorized(address user) internal view returns(bool) {
        return isAuthorized[user];
    }
    
    // Internal function for internal operations - no external call overhead
    function updateBalance(address user, uint amount) internal {
        balances[user] = amount;
    }
    
    // External function with optimized internal calls
    function mintTokens(address recipient, uint amount) external {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(recipient), "User not authorized"); // Direct internal call
        
        uint currentTotal = getTotalTokens(); // Direct internal call
        uint maxAllowed = getMaxSupply();    // Direct internal call
        
        require(currentTotal + amount <= maxAllowed, "Exceeds max supply");
        
        totalTokens = currentTotal + amount;
        updateBalance(recipient, balances[recipient] + amount); // Direct internal call
    }
    
    // External function with optimized internal operations
    function burnTokens(address user, uint amount) external {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(user), "User not authorized"); // Direct internal call
        
        uint currentBalance = balances[user];
        require(currentBalance >= amount, "Insufficient balance");
        
        updateBalance(user, currentBalance - amount); // Direct internal call
        totalTokens -= amount;                        // Direct state modification
    }
    
    // External function with optimized internal operations
    function transferTokens(address from, address to, uint amount) external {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(from) && isUserAuthorized(to), "Users not authorized");
        
        uint fromBalance = balances[from];
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