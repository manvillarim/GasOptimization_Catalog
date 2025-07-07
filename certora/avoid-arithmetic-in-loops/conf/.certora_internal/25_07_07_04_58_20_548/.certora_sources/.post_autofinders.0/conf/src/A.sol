//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract A {
    uint[] public data;
    uint public baseValue = 100;
    uint public multiplier = 5;
    
    function processData() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        for(uint i = 0; i < data.length; i++) {
            // Repetitive calculation inside loop
            uint threshold = baseValue * multiplier + 50;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,threshold)} // Calculated every iteration
            uint factor = multiplier * 2 + 10;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,factor)}           // Calculated every iteration
            
            if(data[i] > threshold) {
                data[i] = data[i] * factor / 100;
            }
        }
    }
    
    function calculateTotals() public view returns(uint total) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        for(uint i = 0; i < data.length; i++) {
            // Division operation repeated in loop
            total += data[i] * baseValue / multiplier;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,total)} // Division every iteration
        }
    }
}