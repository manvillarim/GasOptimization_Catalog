//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Ao {
    uint[] public numbers;
    
    function processNumbers() public {
        uint256 length = numbers.length;
        for(uint256 i = 0; i < length; i++) {
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