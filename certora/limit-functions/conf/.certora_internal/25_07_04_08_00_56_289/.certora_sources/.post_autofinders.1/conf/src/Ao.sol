// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint public total;
    uint public count;
    uint[] public numbers;
    

    function processNumbers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
        // Cache storage variables in memory
        uint tempTotal = total;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,tempTotal)}
        uint tempCount = count;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,tempCount)}
        
        for(uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,tempTotal)} // Memory operation
            tempCount++;            // Memory operation
            
            if(tempTotal > 1000) {
                tempTotal = tempTotal / 2; // Memory operation
            }
        }
        
        // Write back to storage once
        total = tempTotal;
        count = tempCount;
    }
    
    function calculateAverage() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        uint tempTotal = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,tempTotal)} // Local variable
        
        for(uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,tempTotal)} // Only memory operations in loop
        }
        
        total = tempTotal; // Single storage write
    }

    // Getters para a invariante
    function getTotal() external view returns (uint) {
        return total;
    }

    function getCount() external view returns (uint) {
        return count;
    }

    function getNumbersLength() external view returns (uint) {
        return numbers.length;
    }

    function getNumberAt(uint i) external view returns (uint) {
        require(i < numbers.length, "Index out of bounds");
        return numbers[i];
    }
}