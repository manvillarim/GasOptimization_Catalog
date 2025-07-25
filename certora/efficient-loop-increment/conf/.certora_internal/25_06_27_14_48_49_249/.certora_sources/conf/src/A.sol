// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {

    uint256 public data;
    function loop(uint256 n) public{
        for(uint256 i = 0; i < n; i += 1) data += i;
    }

    function getData() external view returns(uint256) {return data;}
}