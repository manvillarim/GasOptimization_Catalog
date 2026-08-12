// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    uint64[] public array1;
    uint64[] public array2;
    uint64 public totalSumOfProducts;

    function push1(uint64 value) external {
        array1.push(value);
    }

    function push2(uint64 value) external {
        array2.push(value);
    }

    function calculateSumOfProducts() external {
        uint64 tempSum = 0;
        for (uint256 i = 0; i < array1.length; i++) {
            for (uint256 j = 0; j < array2.length; j++) {
                unchecked {
                    tempSum += array1[i] * array2[j];
                }
            }
        }
        totalSumOfProducts = tempSum;
    }
}
