//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract A {
    uint[] public data;
    uint public baseValue = 100;
    uint public multiplier = 5;
    
    function processData() public {
        for(uint i = 0; i < data.length; i++) {
            // Repetitive calculation inside loop
            uint threshold = baseValue * multiplier + 50; // Calculated every iteration
            uint factor = multiplier * 2 + 10;           // Calculated every iteration
            
            if(data[i] > threshold) {
                data[i] = data[i] * factor / 100;
            }
        }
    }
    
    function calculateTotals() public view returns(uint total) {
        for(uint i = 0; i < data.length; i++) {
            // Division operation repeated in loop
            total += data[i] * baseValue / multiplier; // Division every iteration
        }
    }
}