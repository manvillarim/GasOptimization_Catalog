// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Suboptimal Function Visibility
 * This contract demonstrates inefficient use of function visibility modifiers
 * leading to higher gas costs and larger bytecode size
 */
contract A {
    address public owner = 0x742D35cC6634c0532925a3b8D0B9B9dC19FAbE07;
    uint private totalTokens;
    uint private maxSupply = 1000000;
    mapping(address => uint) private balances;
    mapping(address => bool) private isAuthorized;
    
    // Public function called only externally - wasteful
    function setOwner(address newOwner) public {
        require(msg.sender == owner, "Not authorized");
        owner = newOwner;
    }
    
    // Public function used internally - creates unnecessary overhead
    function getTotalTokens() public view returns(uint) {
        return totalTokens;
    }
    
    // Public function used internally - wasteful for internal calls
    function getMaxSupply() public view returns(uint) {
        return maxSupply;
    }
    
    // Public function used internally - inefficient
    function isUserAuthorized(address user) public view returns(bool) {
        return isAuthorized[user];
    }
    
    // Public function used internally - creates call overhead
    function updateBalance(address user, uint amount) public {
        require(msg.sender == owner, "Not authorized");
        balances[user] = amount;
    }
    
    // Public function that makes internal calls to other public functions
    function mintTokens(address recipient, uint amount) public {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(recipient), "User not authorized"); // Internal call to public function
        
        uint currentTotal = getTotalTokens(); // Internal call to public function
        uint maxAllowed = getMaxSupply();    // Internal call to public function
        
        require(currentTotal + amount <= maxAllowed, "Exceeds max supply");
        
        totalTokens = currentTotal + amount;
        updateBalance(recipient, balances[recipient] + amount); // Internal call to public function
    }
    
    // Public function making internal calls - inefficient
    function burnTokens(address user, uint amount) public {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(user), "User not authorized"); // Internal call to public function
        
        uint currentBalance = balances[user];
        require(currentBalance >= amount, "Insufficient balance");
        
        updateBalance(user, currentBalance - amount); // Internal call to public function
        totalTokens = getTotalTokens() - amount;      // Internal call to public function
    }
    
    // Public function with internal calls - creates overhead
    function transferTokens(address from, address to, uint amount) public {
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(from) && isUserAuthorized(to), "Users not authorized");
        
        uint fromBalance = balances[from];
        require(fromBalance >= amount, "Insufficient balance");
        
        updateBalance(from, fromBalance - amount);           // Internal call to public function
        updateBalance(to, balances[to] + amount);           // Internal call to public function
    }
    
    // Public function called only externally - should be external
    function authorizeUser(address user) public {
        require(msg.sender == owner, "Not authorized");
        isAuthorized[user] = true;
    }
    
    // Public getter that could be external
    function getBalance(address user) public view returns(uint) {
        return balances[user];
    }
}
