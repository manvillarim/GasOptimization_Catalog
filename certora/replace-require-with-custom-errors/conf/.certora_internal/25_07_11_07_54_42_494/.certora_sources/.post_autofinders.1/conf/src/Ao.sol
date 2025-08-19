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
    
    function expensiveCheck() private returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        expensiveCheckExecuted = true;
        return balance > 1000;
    }
    
    function validateUser(address user) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, user) }
        expensiveCheckExecuted = false;
        
        // Short-circuit: expensiveCheck only called if user != address(0)
        bool result = user != address(0) && expensiveCheck();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,result)}
        
        lastValidationResult = result;
        return result;
    }
    
    function setBalance(uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046000, amount) }
        balance = amount;
    }
}