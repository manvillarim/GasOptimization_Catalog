// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint[] public numbers;
    uint public sum;
    uint public product;
    uint public count;
    
    function processArray() public {
        sum = 0;
        product = 1;
        count = 0;
        
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
            product *= numbers[i];
            if(numbers[i] != 0) {
                count++;
            }
        }
    }
}