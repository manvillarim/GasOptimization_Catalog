// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint public total;
    uint public count;
    uint[] public numbers;
    

    function processNumbers() public {
        // Cache storage variables in memory
        uint tempTotal = total;
        uint tempCount = count;
        
        for(uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i]; // Memory operation
            tempCount++;            // Memory operation
            
            if(tempTotal > 1000) {
                tempTotal = tempTotal / 2; // Memory operation
            }
        }
        
        // Write back to storage once
        total = tempTotal;
        count = tempCount;
    }
    
    function calculateAverage() public {
        uint tempTotal = 0; // Local variable
        
        for(uint i = 0; i < numbers.length; i++) {
            tempTotal += numbers[i]; // Only memory operations in loop
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