
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract A - Without Unchecked Optimization
 */
contract A {
    uint256 private _nextStreamId;
    
    mapping(uint256 => uint256) public balances;
    
    /**
     * @notice Creates a new stream and increments the counter
     */
    function createStream(uint256 amount) external returns (uint256 streamId) {
        require(amount > 0, "Invalid amount");
        
        // Arithmetic with default overflow check
        streamId = _nextStreamId++;
        
        balances[streamId] = amount;
    }
    
    /**
     * @notice Withdraws amount from a stream
     */
    function withdraw(uint256 streamId, uint256 amount) external {
        uint256 balance = balances[streamId];
        
        require(balance >= amount, "Insufficient balance");
        
        // Arithmetic with default overflow check
        uint256 newBalance = balance - amount;
        
        balances[streamId] = newBalance;
    }
    
    /**
     * @notice Adds tokens to multiple accounts
     */
    function batchAdd(address[] calldata accounts, uint256 amount) external {
        require(amount > 0, "Invalid amount");
        
        for (uint256 i = 0; i < accounts.length; i++) {
            // Arithmetic with default overflow check
            uint256 newAmount = amount + i;
            balances[uint256(uint160(accounts[i]))] = newAmount;
        }
    }
}
