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
   function processNumbers() public {
       if (numbers.length >= 3) {
           uint temp = numbers[0];
           numbers[0] = numbers[2];
           numbers[2] = temp;
       }
   }

   /**
    * @dev Increments every number in the array by one.
    */
   function incrementAll() public {
       for(uint i = 0; i < numbers.length; i++) {
           numbers[i]++;
       }
   }

   /**
    * @dev Doubles every number and adds a new value to the end.
    */
   function doubleAndAdd(uint256 newValue) public {
       for(uint i = 0; i < numbers.length; i++) {
           numbers[i] = numbers[i] * 2;
       }
       numbers.push(newValue);
   }
}