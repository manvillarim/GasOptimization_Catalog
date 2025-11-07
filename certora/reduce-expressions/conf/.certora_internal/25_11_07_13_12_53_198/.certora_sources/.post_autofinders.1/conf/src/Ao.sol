// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {

    bool r1;
    uint r2;
    
    function processValues(uint a, uint b, uint c) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016002, c) }
        // Factored expression: 2 * (a + b + c)
        uint result = 2 * (a + b + c);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,result)}
        r2 = result;
    }

}