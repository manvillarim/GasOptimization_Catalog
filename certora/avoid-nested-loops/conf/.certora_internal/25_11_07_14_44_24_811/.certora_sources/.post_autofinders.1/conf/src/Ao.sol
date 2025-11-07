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
    
    function calculateSumOfProducts() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        uint256 sumA = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,sumA)}
        for (uint256 i = 0; i < array1.length; i++) {
            sumA += array1[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,sumA)}
        }

        uint256 sumB = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,sumB)}
        for (uint256 j = 0; j < array2.length; j++) {
            sumB += array2[j];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,sumB)}
        }
        
        totalSumOfProducts = sumA * sumB;
    }
}