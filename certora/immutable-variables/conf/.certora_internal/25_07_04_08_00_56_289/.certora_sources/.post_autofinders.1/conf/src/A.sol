// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public total;
    uint public count;
    uint[] public numbers;
    

    function processNumbers() public {
        for(uint i = 0; i < numbers.length; i++) {
            total += numbers[i];  // Storage write in every iteration
            count++;             // Storage write in every iteration
            
            if(total > 1000) {
                total = total / 2; // Additional storage operations
            }
        }
    }
    
    function calculateAverage() public {
        total = 0; // Storage write
        for(uint i = 0; i < numbers.length; i++) {
            total += numbers[i]; // Storage read and write each iteration
        }
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