// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    uint96 public maxTransactionAmount;
    uint256 public totalSupply;
    uint96 public mintingFee;
    address public owner;
    bool public isPaused;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    
    constructor(
        uint256 _initialSupply,
        address _owner,
        uint96 _fee,
        uint96 _maxTx
    ) {
        totalSupply = _initialSupply;
        owner = _owner;
        mintingFee = _fee;
        maxTransactionAmount = _maxTx;
        balances[_owner] = _initialSupply;
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        require(!isPaused, "Contract is paused");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }
    
    function getBasicInfo() external view returns (bool, address) {
        return (isPaused, owner);
    }
    
    function getSupplyInfo() external view returns (uint256, uint256) {
        return (totalSupply, maxTransactionAmount);
    }
    
    function getOwnerAndFee() external view returns (address, uint256) {
        return (owner, mintingFee);
    }
    
    function checkLimits(uint256 amount) external view returns (bool) {
        return amount <= maxTransactionAmount;
    }
    
    function calculateFees(uint256 amount) external view returns (uint256) {
        return (amount * mintingFee) / 10000;
    }
}