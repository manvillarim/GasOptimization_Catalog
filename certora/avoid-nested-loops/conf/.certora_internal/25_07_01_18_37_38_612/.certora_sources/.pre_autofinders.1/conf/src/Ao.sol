//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Ao {
    uint256[] public numbers;
    
    constructor() {
        numbers = [1, 2, 3, 4, 5];
    }
    
    function processNumbers() external {
        uint256 length = numbers.length;
        for(uint256 i = 0; i < length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function incrementAll() external {
        uint256 length = numbers.length;
        for(uint256 i = 0; i < length; i++) {
            numbers[i] = numbers[i] + 1;
        }
    }
    
    function doubleAndAdd(uint256 value) external {
        uint256 length = numbers.length;
        for(uint256 i = 0; i < length; i++) {
            numbers[i] = (numbers[i] * 2) + value;
        }
    }
    
    function getLength() external view returns (uint256) {
        return numbers.length;
    }
    
    function getNumberAt(uint256 i) external view returns (uint256) {
        require(i < numbers.length, "Index out of bounds");
        return numbers[i];
    }
    
    function getSum() external view returns (uint256) {
        uint256 sum = 0;
        uint256 length = numbers.length; 
        for(uint256 i = 0; i < length; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}
