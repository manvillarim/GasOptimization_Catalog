// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
  uint public valueA;
    uint public valueB;
    
    function swapValues() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        // Single-line swap using tuple assignment
        (valueA, valueB) = (valueB, valueA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020001,0)}
    }
    
    function swapArrayElements(uint[] memory arr, uint i, uint j) public pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026002, j) }
        // Single-line array element swap
        (arr[i], arr[j]) = (arr[j], arr[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020002,0)}
    }
}