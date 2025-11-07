// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ContractA
 * @dev Uses a dynamic array to store numbers.
 */
contract A {
   uint[] public numbers;

   constructor() {
       numbers.push(10);
       numbers.push(20);
       numbers.push(30);
   }

   /**
    * @dev Swaps the first and third elements if the array is long enough.
    */
   function processNumbers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
       if (numbers.length >= 3) {
           uint temp = numbers[0];
           numbers[0] = numbers[2];
           numbers[2] = temp;
       }
   }

   /**
    * @dev Increments every number in the array by one.
    */
   function incrementAll() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
       for(uint i = 0; i < numbers.length; i++) {
           numbers[i]++;
       }
   }

   /**
    * @dev Doubles every number and adds a new value to the end.
    */
   function doubleAndAdd(uint256 newValue) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, newValue) }
       for(uint i = 0; i < numbers.length; i++) {
           numbers[i] = numbers[i] * 2;
       }
       numbers.push(newValue);
   }
}