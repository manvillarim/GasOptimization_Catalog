// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    bool r1;
    uint r2;
    
    function processValues(uint a, uint b, uint c) public{assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006002, c) }
        // Multiple redundant operations
        uint result = (a * 2) + (b * 2) + (c * 2);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,result)}
        r2 = result;
    }
}
