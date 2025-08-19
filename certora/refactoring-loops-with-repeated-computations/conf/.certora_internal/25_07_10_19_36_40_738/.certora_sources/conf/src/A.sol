// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public valueA;
    uint public valueB;
    
    function swapValues() public {
        // Traditional swap using temporary variable
        uint temp = valueA;
        valueA = valueB;
        valueB = temp;
    }
    
    function swapArrayElements(uint[] memory arr, uint i, uint j) public pure {
        // Traditional array element swap
        uint temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}