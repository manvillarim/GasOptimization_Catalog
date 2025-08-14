// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ContractAo
 * @dev Uses a fixed-size array to store numbers, optimizing for gas.
 */
contract Ao {
    uint[100] public numbers; // Fixed size
    uint public currentLength;

    constructor() {
        numbers[0] = 10;
        numbers[1] = 20;
        numbers[2] = 30;
        currentLength = 3;
    }

    /**
    * @dev Swaps the first and third elements if the array is long enough.
    */
    function processNumbers() public {
       if (currentLength >= 3) {
           uint temp = numbers[0];
           numbers[0] = numbers[2];
           numbers[2] = temp;
       }
    }
    
    /**
    * @dev Increments every active number in the array by one.
    */
    function incrementAll() public {
        for(uint i = 0; i < currentLength; i++) {
            numbers[i]++;
        }
    }

    /**
    * @dev Doubles every active number and adds a new value.
    */
    function doubleAndAdd(uint256 newValue) public {
        require(currentLength < 100, "Array overflow");
        for(uint i = 0; i < currentLength; i++) {
            numbers[i] = numbers[i] * 2;
        }
        numbers[currentLength] = newValue;
        currentLength++;
    }
}