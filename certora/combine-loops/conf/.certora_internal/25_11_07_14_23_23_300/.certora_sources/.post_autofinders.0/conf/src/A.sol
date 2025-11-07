// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint[] public numbers;
    uint public sum;
    uint public product;
    uint public count;
    
    function processArray() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        sum = 0;
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        
        product = 1;
        for(uint i = 0; i < numbers.length; i++) {
            product *= numbers[i];
        }
        
        count = 0;
        for(uint i = 0; i < numbers.length; i++) {
            if(numbers[i] != 0) {
                count++;
            }
        }
    }
}