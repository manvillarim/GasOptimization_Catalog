// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato original - com overflow/underflow checks
contract A {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    
    constructor() {
        totalSupply = 1000000;
        balances[msg.sender] = totalSupply;
    }
    
    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    
    function batchTransfer(address[] calldata recipients, uint256 amount) external {
        uint256 totalAmount = recipients.length * amount;
        require(balances[msg.sender] >= totalAmount, "Insufficient balance");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            balances[msg.sender] -= amount;
            balances[recipients[i]] += amount;
        }
    }
    
    function decrementCounter(uint256 start, uint256 iterations) external pure returns (uint256) {
        require(start >= iterations, "Start must be >= iterations");
        
        uint256 counter = start;
        for (uint256 i = 0; i < iterations; i++) {
            counter--;
        }
        return counter;
    }
}

// Contrato otimizado - usando unchecked para operações validadas
contract Ao {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    
    constructor() {
        totalSupply = 1000000;
        balances[msg.sender] = totalSupply;
    }
    
    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");
        
        unchecked {
            balances[msg.sender] -= amount;
        }
        balances[to] += amount;
    }
    
    function batchTransfer(address[] calldata recipients, uint256 amount) external {
        uint256 totalAmount = recipients.length * amount;
        require(balances[msg.sender] >= totalAmount, "Insufficient balance");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            unchecked {
                balances[msg.sender] -= amount;
            }
            balances[recipients[i]] += amount;
        }
    }
    
    function decrementCounter(uint256 start, uint256 iterations) external pure returns (uint256) {
        require(start >= iterations, "Start must be >= iterations");
        
        uint256 counter = start;
        for (uint256 i = 0; i < iterations; i++) {
            unchecked {
                counter--;
            }
        }
        return counter;
    }
}