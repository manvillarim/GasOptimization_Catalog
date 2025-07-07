//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Ao {
    uint[] public data;
    uint public baseValue = 100;
    uint public multiplier = 5;
    
    function processData() public {
        // Pre-calculate constants outside loop
        uint threshold = baseValue * multiplier + 50; // Calculated once
        uint factor = multiplier * 2 + 10;           // Calculated once
        
        for(uint i = 0; i < data.length; i++) {
            if(data[i] > threshold) {
                data[i] = data[i] * factor / 100;
            }
        }
    }
    
    function calculateTotals() public view returns(uint total) {
        // Pre-calculate to avoid division in loop
        uint multipliedBase = baseValue * 1000; // Multiply instead of divide
        
        for(uint i = 0; i < data.length; i++) {
            total += data[i] * multipliedBase / (multiplier * 1000);
        }
    }
}