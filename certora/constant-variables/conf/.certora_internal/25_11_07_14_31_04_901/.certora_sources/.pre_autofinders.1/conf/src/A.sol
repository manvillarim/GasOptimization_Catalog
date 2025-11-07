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
    function getBasicInfo() public view returns(uint8) {
        return decimals; // SLOAD operation
    }
    
    function getSupplyInfo() public view returns(uint, uint) {
        return (totalSupply, maxTransactionAmount); // SLOAD operations
    }
    
    function getOwnerAndFee() public view returns(address, uint) {
        return (owner, mintingFee); // SLOAD operations
    }
    
    function checkLimits(uint amount) public view returns(bool) {
        return amount <= maxTransactionAmount && !isPaused; // Multiple SLOAD operations
    }
    
    // Transfer function that reads multiple state variables
    function transfer(address to, uint amount) public returns(bool) {
        require(!isPaused, "Contract is paused"); // SLOAD
        require(amount <= maxTransactionAmount, "Exceeds max transaction"); // SLOAD
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        return true;
    }
    
    // Function to calculate fees
    function calculateFees(uint amount) public view returns(uint) {
        if (amount > maxTransactionAmount) { // SLOAD
            return mintingFee * 2; // SLOAD
        }
        return mintingFee; // SLOAD
    }
}