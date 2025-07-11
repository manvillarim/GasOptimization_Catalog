// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public balance;
    bool public expensiveCheckExecuted;
    bool public lastValidationResult;
    
    constructor() {
        balance = 500;
        expensiveCheckExecuted = false;
        lastValidationResult = false;
    }
    
    function expensiveCheck() private returns(bool) {
        expensiveCheckExecuted = true;
        return balance > 1000;
    }
    
    function validateUser(address user) public returns(bool) {
        expensiveCheckExecuted = false;
        
        bool isValid = false;
        bool hasBalance = expensiveCheck(); // Always executed
        
        if(user != address(0) && hasBalance) {
            isValid = true;
        }
        
        lastValidationResult = isValid;
        return isValid;
    }
    
    function setBalance(uint amount) public {
        balance = amount;
    }
}