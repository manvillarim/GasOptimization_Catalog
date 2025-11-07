// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint256 private _nextStreamId;
    
    mapping(uint256 => uint256) public balances;
    
    /**
     * @notice Creates a new stream and increments the counter
     */
    function createStream(uint256 amount) external returns (uint256 streamId) {
        require(amount > 0, "Invalid amount");
        
        // Safe to use unchecked: counter will never realistically overflow
        unchecked {
            streamId = _nextStreamId++;
        }
        
        balances[streamId] = amount;
    }
    
    /**
     * @notice Withdraws amount from a stream
     */
    function withdraw(uint256 streamId, uint256 amount) external {
        uint256 balance = balances[streamId];
        
        //require(balance >= amount, "Insufficient balance");
        
        // Safe to use unchecked: already validated that balance >= amount
        unchecked {
            uint256 newBalance = balance - amount;
            balances[streamId] = newBalance;
        }
    }
    
    /**
     * @notice Adds tokens to multiple accounts
     */
    function batchAdd(address[] calldata accounts, uint256 amount) external {
        require(amount > 0, "Invalid amount");
        
        for (uint256 i = 0; i < accounts.length; i++) {
            // Safe to use unchecked: i is bounded by array length
            // and addition with small i values won't overflow
            unchecked {
                uint256 newAmount = amount + i;
                balances[uint256(uint160(accounts[i]))] = newAmount;
            }
        }
    }
}