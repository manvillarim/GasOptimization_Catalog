// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
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
        
        // Short-circuit: expensiveCheck only called if user != address(0)
        bool result = user != address(0) && expensiveCheck();
        
        lastValidationResult = result;
        return result;
    }
    
    function setBalance(uint amount) public {
        balance = amount;
    }
}