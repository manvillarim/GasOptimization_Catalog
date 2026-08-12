// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    uint256 public counter = 0;
    bool public flag = false;
    address public owner = address(0);

    function setOwner(address newOwner) external {
        owner = newOwner;
    }

    function bump() external {
        counter += 1;
        flag = true;
    }

    function processArray(uint256[] memory data) external pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < data.length; i++) {
            sum += data[i];
        }
        return sum;
    }
}
