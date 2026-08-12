// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    address public owner;
    uint256 public creationTime;
    uint256 public maxSupply;
    mapping(address => uint256) public balances;

    constructor(uint256 _maxSupply) {
        owner = msg.sender;
        creationTime = block.timestamp;
        maxSupply = _maxSupply;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        require(balances[to] + amount <= maxSupply, "Exceeds max supply");
        balances[to] += amount;
    }

    function getInfo() external view returns (address, uint256, uint256) {
        return (owner, creationTime, maxSupply);
    }
}
