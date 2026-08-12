// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    uint256 public constant maxSupply = 1000000;
    uint256 public constant mintingFee = 0.001 ether;
    bool public isPaused;
    mapping(address => uint256) public balances;

    function setPaused(bool paused) external {
        isPaused = paused;
    }

    function credit(address user, uint256 amount) external {
        balances[user] += amount;
    }

    function checkLimits(uint256 amount) external view returns (bool) {
        return amount <= maxSupply && !isPaused;
    }

    function calculateFees(uint256 amount) external pure returns (uint256) {
        if (amount > maxSupply) {
            return mintingFee * 2;
        }
        return mintingFee;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(!isPaused, "Contract is paused");
        require(amount <= maxSupply, "Exceeds max supply");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }
}
