// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public isAuthorized;

    constructor() {
        owner = msg.sender;
    }

    function authorize(address user) public {
        require(msg.sender == owner, "Not owner");
        isAuthorized[user] = true;
    }

    function setBalance(address user, uint256 amount) public {
        require(msg.sender == owner, "Not owner");
        balances[user] = amount;
    }

    function credit(address user, uint256 amount) public {
        require(msg.sender == owner, "Not owner");
        require(isAuthorized[user], "Not authorized");
        setBalance(user, balances[user] + amount);
    }

    function balanceOf(address user) public view returns (uint256) {
        return balances[user];
    }
}
