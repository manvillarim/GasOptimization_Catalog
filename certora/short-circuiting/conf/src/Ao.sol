// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
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
        // Short-circuit: the cheap stack comparison is evaluated first, so the
        // SLOAD inside expensiveCheck is skipped whenever user == address(0).
        bool result = user != address(0) && expensiveCheck();

        lastValidationResult = result;
        return result;
    }

    function setBalance(uint amount) public {
        balance = amount;
    }
}
