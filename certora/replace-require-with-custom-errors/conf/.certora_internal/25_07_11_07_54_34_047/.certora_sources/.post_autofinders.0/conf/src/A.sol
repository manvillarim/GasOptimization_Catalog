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
    
    function expensiveCheck() private returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        expensiveCheckExecuted = true;
        return balance > 1000;
    }
    
    function validateUser(address user) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026000, user) }
        expensiveCheckExecuted = false;
        
        bool isValid = false;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,isValid)}
        bool hasBalance = expensiveCheck();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,hasBalance)} // Always executed
        
        if(user != address(0) && hasBalance) {
            isValid = true;
        }
        
        lastValidationResult = isValid;
        return isValid;
    }
    
    function setBalance(uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016000, amount) }
        balance = amount;
    }
}