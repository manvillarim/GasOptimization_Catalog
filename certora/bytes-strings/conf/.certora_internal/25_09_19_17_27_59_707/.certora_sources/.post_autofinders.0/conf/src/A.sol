//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract A {
    uint256[] public numbers;
    
    
    function processNumbers() external {

        for(uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function incrementAll() external {

        for(uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] + 1;
        }
    }
    
    function doubleAndAdd(uint256 value) external {

        for(uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = (numbers[i] * 2) + value;
        }
    }
    
    
}