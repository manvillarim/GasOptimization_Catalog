// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    
    uint96 public immutable MAX_TRANSACTION_AMOUNT;
    uint96 public immutable MINTING_FEE;
    
    address public immutable OWNER;
    bool public isPaused; 

    uint256 public immutable TOTAL_SUPPLY;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    constructor(uint256 _initialSupply, address _owner, uint96 _fee, uint96 _maxTx) {
        TOTAL_SUPPLY = _initialSupply;
        OWNER = _owner;
        MINTING_FEE = _fee;
        MAX_TRANSACTION_AMOUNT = _maxTx;
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
        return (isPaused, OWNER);
    }

    function getSupplyInfo() external view returns (uint256, uint256) {
        return (TOTAL_SUPPLY, MAX_TRANSACTION_AMOUNT);
    }

    function getOwnerAndFee() external view returns (address, uint256) {
        return (OWNER, MINTING_FEE);
    }

    function checkLimits(uint256 amount) external view returns (bool) {
        return amount <= MAX_TRANSACTION_AMOUNT;
    }

    function calculateFees(uint256 amount) external view returns (uint256) {
        return (amount * MINTING_FEE) / 10000;
    }
}