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
    string public constant NAME = "ConstantToken";
    string public constant SYMBOL = "CTK";
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
    function getBasicInfo() public pure returns(string memory, string memory, uint8) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060004, 0) }
        return (NAME, SYMBOL, DECIMALS); // No SLOAD operations, direct values
    }
    
    function getSupplyInfo() public pure returns(uint, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) }
        return (TOTAL_SUPPLY, MAX_TRANSACTION_AMOUNT); // Direct values from bytecode
    }
    
    function getOwnerAndFee() public pure returns(address, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0004, 0) }
        return (OWNER, MINTING_FEE); // Direct values from bytecode
    }
    
    function checkLimits(uint amount) public view returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00096000, amount) }
        return amount <= MAX_TRANSACTION_AMOUNT && !isPaused; // Only one SLOAD for isPaused
    }
    
    // Transfer function with optimized constant usage
    function transfer(address to, uint amount) public returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d6001, amount) }
        require(!isPaused, "Contract is paused"); // Only SLOAD needed
        require(amount <= MAX_TRANSACTION_AMOUNT, "Exceeds max transaction"); // Direct constant
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        return true;
    }
    
    // Function to calculate fees using constants
    function calculateFees(uint amount) public pure returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0000, 1037618708494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e6000, amount) }
        if (amount > MAX_TRANSACTION_AMOUNT) { // Direct constant comparison
            return MINTING_FEE * 2; // Direct constant value
        }
        return MINTING_FEE; // Direct constant value
    }
    
    // Additional utility functions that benefit from constants
    function isValidAmount(uint amount) public pure returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076000, amount) }
        return amount > 0 && amount <= MAX_TRANSACTION_AMOUNT;
    }
    
    function getMaxAllowedAmount() public pure returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080004, 0) }
        return MAX_TRANSACTION_AMOUNT; // No storage read required
    }
    
    function getContractOwner() public pure returns(address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0004, 0) }
        return OWNER; // Direct constant access
    }
}