// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint256[] public array1;
    uint256[] public array2;
    uint256 public totalSumOfProducts;

    constructor(uint256[] memory _array1, uint256[] memory _array2) {
        array1 = _array1;
        array2 = _array2;
    }
    
    function calculateSumOfProducts() public {
        uint256 sumA = 0;
        for (uint256 i = 0; i < array1.length; i++) {
            sumA += array1[i];
        }

        uint256 sumB = 0;
        for (uint256 j = 0; j < array2.length; j++) {
            sumB += array2[j];
        }
        
        totalSumOfProducts = sumA * sumB;
    }
}