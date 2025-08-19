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

    function expensiveCheck(address user) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, user) }
        // Simulate an expensive operation, updating a flag for CVL
        expensiveCheckExecuted = true;
        uint balance = balances[user];uint256 certora_local1 = balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,certora_local1)}
        expensiveCheckBalance = balance; // Capture balance for CVL
        return balance > 1000;
    }
    
    function validateUser(address user) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026000, user) }
        expensiveCheckExecuted = false; // Reset flag before each call
        expensiveCheckBalance = 0;      // Reset captured balance
        
        bool isValid = false;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,isValid)}
        bool hasBalance = expensiveCheck(user);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,hasBalance)} // Always executed
        
        if(user != address(0) && hasBalance) {
            isValid = true;
        }
        lastValidationResult = isValid; // Capture result for CVL
        return isValid;
    }

    // Auxiliary function for CVL to set balances
    function setBalance(address user, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016001, amount) }
        balances[user] = amount;
    }
}