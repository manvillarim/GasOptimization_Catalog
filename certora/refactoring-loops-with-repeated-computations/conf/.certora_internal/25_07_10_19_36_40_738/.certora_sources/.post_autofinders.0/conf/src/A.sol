// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public valueA;
    uint public valueB;
    
    function swapValues() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        // Traditional swap using temporary variable
        uint temp = valueA;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,temp)}
        valueA = valueB;
        valueB = temp;
    }
    
    function swapArrayElements(uint[] memory arr, uint i, uint j) public pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006002, j) }
        // Traditional array element swap
        uint temp = arr[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,temp)}
        arr[i] = arr[j];uint256 certora_local3 = arr[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,certora_local3)}
        arr[j] = temp;uint256 certora_local4 = arr[j];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,certora_local4)}
    }
}