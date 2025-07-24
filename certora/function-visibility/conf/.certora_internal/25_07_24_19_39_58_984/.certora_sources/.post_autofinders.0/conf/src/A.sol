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
    function setOwner(address newOwner) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076000, newOwner) }
        require(msg.sender == owner, "Not authorized");
        owner = newOwner;
    }
    
    // Public function used internally - creates unnecessary overhead
    function getTotalTokens() public view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
        return totalTokens;
    }
    
    // Public function used internally - wasteful for internal calls
    function getMaxSupply() public view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        return maxSupply;
    }
    
    // Public function used internally - inefficient
    function isUserAuthorized(address user) public view returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046000, user) }
        return isAuthorized[user];
    }
    
    // Public function used internally - creates call overhead
    function updateBalance(address user, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036001, amount) }
        require(msg.sender == owner, "Not authorized");
        balances[user] = amount;
    }
    
    // Public function that makes internal calls to other public functions
    function mintTokens(address recipient, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00086001, amount) }
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(recipient), "User not authorized"); // Internal call to public function
        
        uint currentTotal = getTotalTokens();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,currentTotal)} // Internal call to public function
        uint maxAllowed = getMaxSupply();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,maxAllowed)}    // Internal call to public function
        
        require(currentTotal + amount <= maxAllowed, "Exceeds max supply");
        
        totalTokens = currentTotal + amount;
        updateBalance(recipient, balances[recipient] + amount); // Internal call to public function
    }
    
    // Public function making internal calls - inefficient
    function burnTokens(address user, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056001, amount) }
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(user), "User not authorized"); // Internal call to public function
        
        uint currentBalance = balances[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,currentBalance)}
        require(currentBalance >= amount, "Insufficient balance");
        
        updateBalance(user, currentBalance - amount); // Internal call to public function
        totalTokens = getTotalTokens() - amount;      // Internal call to public function
    }
    
    // Public function with internal calls - creates overhead
    function transferTokens(address from, address to, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00096002, amount) }
        require(msg.sender == owner, "Not authorized");
        require(isUserAuthorized(from) && isUserAuthorized(to), "Users not authorized");
        
        uint fromBalance = balances[from];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,fromBalance)}
        require(fromBalance >= amount, "Insufficient balance");
        
        updateBalance(from, fromBalance - amount);           // Internal call to public function
        updateBalance(to, balances[to] + amount);           // Internal call to public function
    }
    
    // Public function called only externally - should be external
    function authorizeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, user) }
        require(msg.sender == owner, "Not authorized");
        isAuthorized[user] = true;
    }
    
    // Public getter that could be external
    function getBalance(address user) public view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00066000, user) }
        return balances[user];
    }
}
