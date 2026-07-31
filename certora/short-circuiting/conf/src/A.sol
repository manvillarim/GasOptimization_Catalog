// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public balance;
    bool public lastValidationResult;

    constructor() {
        balance = 500;
        lastValidationResult = false;
    }

    // Expensive because it reads persistent storage (SLOAD), but free of side
    // effects: this is the applicability condition of the short-circuiting
    // rule. An operand that may be skipped must not modify the state.
    function expensiveCheck() private view returns(bool) {
        return balance > 1000;
    }

    function validateUser(address user) public returns(bool) {
        bool isValid = false;
        bool hasBalance = expensiveCheck(); // Always executed: SLOAD every call

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
