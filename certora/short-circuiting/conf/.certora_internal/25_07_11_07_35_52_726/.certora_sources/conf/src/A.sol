// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    mapping(address => uint) public balances;
    
    // Variables to capture state and results for CVL
    bool public expensiveCheckExecuted;
    uint public expensiveCheckBalance;
    bool public lastValidationResult;

    constructor() {
        // Initialize some balances for testing
        balances[address(0x1)] = 500;
        balances[address(0x2)] = 2000;
        expensiveCheckExecuted = false;
        expensiveCheckBalance = 0;
        lastValidationResult = false;
    }

    function expensiveCheck(address user) public returns(bool) {
        // Simulate an expensive operation, updating a flag for CVL
        expensiveCheckExecuted = true;
        uint balance = balances[user];
        expensiveCheckBalance = balance; // Capture balance for CVL
        return balance > 1000;
    }
    
    function validateUser(address user) public returns(bool) {
        expensiveCheckExecuted = false; // Reset flag before each call
        expensiveCheckBalance = 0;      // Reset captured balance
        
        bool isValid = false;
        bool hasBalance = expensiveCheck(user); // Always executed
        
        if(user != address(0) && hasBalance) {
            isValid = true;
        }
        lastValidationResult = isValid; // Capture result for CVL
        return isValid;
    }

    // Auxiliary function for CVL to set balances
    function setBalance(address user, uint amount) public {
        balances[user] = amount;
    }
}