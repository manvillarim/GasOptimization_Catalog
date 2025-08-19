// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
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
    
    function expensiveCheck(address user) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036000, user) }
        // Simulate an expensive operation, updating a flag for CVL
        expensiveCheckExecuted = true;
        uint balance = balances[user];uint256 certora_local1 = balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,certora_local1)}
        expensiveCheckBalance = balance; // Capture balance for CVL
        return balance > 1000;
    }
    
    function validateUser(address user) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, user) }
        expensiveCheckExecuted = false; // Reset flag before each call
        expensiveCheckBalance = 0;      // Reset captured balance
        
        // Short-circuit: expensiveCheck() is only called if user != address(0)
        bool result = user != address(0) && expensiveCheck(user);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,result)}
        lastValidationResult = result; // Capture result for CVL
        return result;
    }

    // Auxiliary function for CVL to set balances
    function setBalance(address user, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046001, amount) }
        balances[user] = amount;
    }
}