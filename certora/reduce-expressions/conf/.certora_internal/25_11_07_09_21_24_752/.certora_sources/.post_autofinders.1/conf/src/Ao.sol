// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {

    bool r1;
    uint r2;
    function calculateResult(bool x, bool y) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036001, y) }
        // Reduced expression using De Morgan's law: !(x || y)
        bool result = !(x || y);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,result)}
        r1 = result;
    }
    
    function processValues(uint a, uint b, uint c) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026002, c) }
        // Factored expression: 2 * (a + b + c)
        uint result = 2 * (a + b + c);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,result)}
        r2 = result;
    }

}