// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    bool r1;
    uint r2;
    function calculateResult(bool x, bool y) public {
        // Complex expression: !x && !y
        bool result = (!x) && (!y);
        r1 = result;
    }
    
    function processValues(uint a, uint b, uint c) public{
        // Multiple redundant operations
        uint result = (a * 2) + (b * 2) + (c * 2);
        r2 = result;
    }
}
