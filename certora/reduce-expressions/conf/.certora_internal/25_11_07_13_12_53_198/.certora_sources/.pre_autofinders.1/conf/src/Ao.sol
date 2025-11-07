// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {

    bool r1;
    uint r2;
    
    function processValues(uint a, uint b, uint c) public {
        // Factored expression: 2 * (a + b + c)
        uint result = 2 * (a + b + c);
        r2 = result;
    }

}