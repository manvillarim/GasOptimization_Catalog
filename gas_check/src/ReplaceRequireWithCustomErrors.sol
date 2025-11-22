// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato original - usando require com string
contract A {
    mapping(address => uint256) public balances;
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(amount > 0, "Withdrawal amount must be greater than zero");
        
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    
    function transfer(address to, uint256 amount) external {
        require(to != address(0), "Cannot transfer to zero address");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(amount > 0, "Transfer amount must be greater than zero");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

// Contrato otimizado - usando custom errors
contract Ao {
    mapping(address => uint256) public balances;
    address public owner;
    
    error DepositAmountMustBeGreaterThanZero();
    error InsufficientBalance();
    error WithdrawalAmountMustBeGreaterThanZero();
    error CannotTransferToZeroAddress();
    error TransferAmountMustBeGreaterThanZero();
    
    constructor() {
        owner = msg.sender;
    }
    
    function deposit() external payable {
        if (!(msg.value > 0)) {
            revert DepositAmountMustBeGreaterThanZero();
        }
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) external {
        if (!(balances[msg.sender] >= amount)) {
            revert InsufficientBalance();
        }
        if (!(amount > 0)) {
            revert WithdrawalAmountMustBeGreaterThanZero();
        }
        
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    
    function transfer(address to, uint256 amount) external {
        if (!(to != address(0))) {
            revert CannotTransferToZeroAddress();
        }
        if (!(balances[msg.sender] >= amount)) {
            revert InsufficientBalance();
        }
        if (!(amount > 0)) {
            revert TransferAmountMustBeGreaterThanZero();
        }
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}