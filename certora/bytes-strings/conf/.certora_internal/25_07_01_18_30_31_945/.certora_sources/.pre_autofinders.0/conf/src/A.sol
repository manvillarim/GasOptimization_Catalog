//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract A {
    uint256[] public numbers;
    
    function processNumbers() public {
        for(uint i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function getNumbers() external view returns(uint256[] memory) {
        return numbers;
    }

    function getLength() external view returns (uint256) {
        return numbers.length;
    }

    function getNumberAt(uint256 i) external view returns (uint256) {
        return numbers[i];
    }
}