//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Ao {
    uint[] public data;
    uint public baseValue = 100;
    uint public multiplier = 5;
    
    function processData() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        // Pre-calculate constants outside loop
        uint threshold = baseValue * multiplier + 50;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,threshold)} // Calculated once
        uint factor = multiplier * 2 + 10;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,factor)}           // Calculated once
        
        for(uint i = 0; i < data.length; i++) {
            if(data[i] > threshold) {
                data[i] = data[i] * factor / 100;
            }
        }
    }
    
    function calculateTotals() public view returns(uint total) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
        // Pre-calculate to avoid division in loop
        uint multipliedBase = baseValue * 1000;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,multipliedBase)} // Multiply instead of divide
        
        for(uint i = 0; i < data.length; i++) {
            total += data[i] * multipliedBase / (multiplier * 1000);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,total)}
        }
    }
}