//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract A {
    uint256[] public numbers;
    
    function processNumbers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
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