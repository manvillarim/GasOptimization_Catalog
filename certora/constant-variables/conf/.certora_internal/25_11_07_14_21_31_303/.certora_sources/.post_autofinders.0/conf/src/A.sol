// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Using Regular State Variables
 * This contract demonstrates the use of regular state variables
 * which consume storage slots and require SLOAD operations
 */
contract A {
    // Regular state variables - stored in contract storage
    uint public totalSupply = 10000000;
    string public name = "RegularToken";
    string public symbol = "RTK";
    uint8 public decimals = 18;
    address public owner = 0x742D35cC6634c0532925a3b8D0B9B9dC19FAbE07;
    uint public mintingFee = 0.001 ether;
    bool public isPaused = false;
    uint public maxTransactionAmount = 100000;
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;
    
    constructor() {
        balances[owner] = totalSupply;
    }
    
    // Functions that read from storage (expensive gas operations)
    function getBasicInfo() public view returns(string memory, string memory, uint8) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        return (name, symbol, decimals); // Multiple SLOAD operations
    }
    
    function getSupplyInfo() public view returns(uint, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
        return (totalSupply, maxTransactionAmount); // SLOAD operations
    }
    
    function getOwnerAndFee() public view returns(address, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        return (owner, mintingFee); // SLOAD operations
    }
    
    function checkLimits(uint amount) public view returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, amount) }
        return amount <= maxTransactionAmount && !isPaused; // Multiple SLOAD operations
    }
    
    // Transfer function that reads multiple state variables
    function transfer(address to, uint amount) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046001, amount) }
        require(!isPaused, "Contract is paused"); // SLOAD
        require(amount <= maxTransactionAmount, "Exceeds max transaction"); // SLOAD
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        return true;
    }
    
    // Function to calculate fees
    function calculateFees(uint amount) public view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, amount) }
        if (amount > maxTransactionAmount) { // SLOAD
            return mintingFee * 2; // SLOAD
        }
        return mintingFee; // SLOAD
    }
}