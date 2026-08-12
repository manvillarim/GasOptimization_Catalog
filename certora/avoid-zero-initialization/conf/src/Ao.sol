// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    uint256 public counter;
    bool public flag;
    address public owner;

    function setOwner(address newOwner) external {
        owner = newOwner;
    }

    function bump() external {
        counter += 1;
        flag = true;
    }

    function processArray(uint256[] memory data) external pure returns (uint256) {
        uint256 sum;
        for (uint256 i; i < data.length; i++) {
            sum += data[i];
        }
        return sum;
    }
}
