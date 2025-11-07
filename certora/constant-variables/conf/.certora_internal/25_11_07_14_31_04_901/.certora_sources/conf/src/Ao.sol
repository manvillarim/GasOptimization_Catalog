// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Using Constant Variables (Optimized)
 * This contract demonstrates the use of constant variables
 * which are embedded directly in bytecode, eliminating storage reads
 */
contract Ao {
    // Constant variables - compiled into bytecode, no storage slots used
    uint public constant TOTAL_SUPPLY = 10000000;
    uint8 public constant DECIMALS = 18;
    address public constant OWNER = 0x742D35cC6634c0532925a3b8D0B9B9dC19FAbE07;
    uint public constant MINTING_FEE = 0.001 ether;
    uint public constant MAX_TRANSACTION_AMOUNT = 100000;
    
    // Only variables that can change need to be state variables
    bool public isPaused = false;
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;
    
    constructor() {
        balances[OWNER] = TOTAL_SUPPLY;
    }
    
    // Functions that use constants (no storage reads, cheaper gas)
    function getBasicInfo() public pure returns(uint8) {
        return DECIMALS; // No SLOAD operation, direct value
    }
    
    function getSupplyInfo() public pure returns(uint, uint) {
        return (TOTAL_SUPPLY, MAX_TRANSACTION_AMOUNT); // Direct values from bytecode
    }
    
    function getOwnerAndFee() public pure returns(address, uint) {
        return (OWNER, MINTING_FEE); // Direct values from bytecode
    }
    
    function checkLimits(uint amount) public view returns(bool) {
        return amount <= MAX_TRANSACTION_AMOUNT && !isPaused; // Only one SLOAD for isPaused
    }
    
    // Transfer function with optimized constant usage
    function transfer(address to, uint amount) public returns(bool) {
        require(!isPaused, "Contract is paused"); // Only SLOAD needed
        require(amount <= MAX_TRANSACTION_AMOUNT, "Exceeds max transaction"); // Direct constant
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        return true;
    }
    
    // Function to calculate fees using constants
    function calculateFees(uint amount) public pure returns(uint) {
        if (amount > MAX_TRANSACTION_AMOUNT) { // Direct constant comparison
            return MINTING_FEE * 2; // Direct constant value
        }
        return MINTING_FEE; // Direct constant value
    }
    
    // Additional utility functions that benefit from constants
    function isValidAmount(uint amount) public pure returns(bool) {
        return amount > 0 && amount <= MAX_TRANSACTION_AMOUNT;
    }
    
    function getMaxAllowedAmount() public pure returns(uint) {
        return MAX_TRANSACTION_AMOUNT; // No storage read required
    }
    
    function getContractOwner() public pure returns(address) {
        return OWNER; // Direct constant access
    }
}