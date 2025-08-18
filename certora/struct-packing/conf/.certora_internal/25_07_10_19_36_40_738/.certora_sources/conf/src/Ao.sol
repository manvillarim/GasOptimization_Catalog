// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
  uint public valueA;
    uint public valueB;
    
    function swapValues() public {
        // Single-line swap using tuple assignment
        (valueA, valueB) = (valueB, valueA);
    }
    
    function swapArrayElements(uint[] memory arr, uint i, uint j) public pure {
        // Single-line array element swap
        (arr[i], arr[j]) = (arr[j], arr[i]);
    }
}