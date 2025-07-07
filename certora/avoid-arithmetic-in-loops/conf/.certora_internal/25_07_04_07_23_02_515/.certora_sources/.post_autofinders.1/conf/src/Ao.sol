//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Ao {
    uint256[] public numbers;
    
    
    function processNumbers() external {
        uint256 length = numbers.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        for(uint256 i = 0; i < length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function incrementAll() external {
        uint256 length = numbers.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,length)}
        for(uint256 i = 0; i < length; i++) {
            numbers[i] = numbers[i] + 1;
        }
    }
    
    function doubleAndAdd(uint256 value) external {
        uint256 length = numbers.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,length)}
        for(uint256 i = 0; i < length; i++) {
            numbers[i] = (numbers[i] * 2) + value;
        }
    }


}
