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
    function processNumbers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040004, 0) }
       if (currentLength >= 3) {
           uint temp = numbers[0];
           numbers[0] = numbers[2];
           numbers[2] = temp;
       }
    }
    
    /**
    * @dev Increments every active number in the array by one.
    */
    function incrementAll() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050004, 0) }
        for(uint i = 0; i < currentLength; i++) {
            numbers[i]++;
        }
    }

    /**
    * @dev Doubles every active number and adds a new value.
    */
    function doubleAndAdd(uint256 newValue) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036000, newValue) }
        require(currentLength < 100, "Array overflow");
        for(uint i = 0; i < currentLength; i++) {
            numbers[i] = numbers[i] * 2;
        }
        numbers[currentLength] = newValue;
        currentLength++;
    }
}