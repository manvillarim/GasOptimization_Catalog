// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint256[] public array1;
    uint256[] public array2;
    uint256 public totalSumOfProducts;

    constructor(uint256[] memory _array1, uint256[] memory _array2) {
        array1 = _array1;
        array2 = _array2;
    }
    
    function calculateSumOfProducts() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        uint256 tempSum = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,tempSum)}
        for (uint256 i = 0; i < array1.length; i++) {
            for (uint256 j = 0; j < array2.length; j++) {
                tempSum += array1[i] * array2[j];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,tempSum)}
            }
        }
        totalSumOfProducts = tempSum;
    }
}