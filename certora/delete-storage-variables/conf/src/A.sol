// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    mapping(address => uint256) private balances;
    mapping(address => bool) private isRegistered;

    function register() external {
        require(!isRegistered[msg.sender], "Already registered");
        isRegistered[msg.sender] = true;
        balances[msg.sender] = 1000;
    }

    function removeUser(address user) external {
        require(isRegistered[user], "Not registered");
        isRegistered[user] = false;
    }

    function balanceOf(address user) external view returns (uint256) {
        return isRegistered[user] ? balances[user] : 0;
    }

    function registeredOf(address user) external view returns (bool) {
        return isRegistered[user];
    }
}
