// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {

    uint256 public data;
    function loop(uint256 n) public{assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016000, n) }
        for(uint256 i = 0; i < n; i ++) data += i;
    }

    function getData() external view returns(uint256) {return data;}
}