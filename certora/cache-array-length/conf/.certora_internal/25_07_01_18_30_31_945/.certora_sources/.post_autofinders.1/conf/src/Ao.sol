//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Ao {
    uint[] public numbers;
    
    function processNumbers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        uint256 length = numbers.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
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