// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
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
        uint64 sumA = 0;
        for (uint256 i = 0; i < array1.length; i++) {
            unchecked {
                sumA += array1[i];
            }
        }

        uint64 sumB = 0;
        for (uint256 j = 0; j < array2.length; j++) {
            unchecked {
                sumB += array2[j];
            }
        }

        unchecked {
            totalSumOfProducts = sumA * sumB;
        }
    }
}
