// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - With Storage Cleanup Optimization
 * This contract demonstrates efficient storage management
 * by deleting unused storage variables to get gas refunds
 */
contract Ao {
    // Storage variables for user management
    mapping(address => uint256) public balances;
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public lastActivityTime;
    mapping(address => string) public usernames;
    mapping(address => uint256) public rewardPoints;
    
    // Array to track all users
    address[] public allUsers;
    mapping(address => uint256) public userIndex;
    
    // Contract state variables
    uint256 public totalUsers;
    uint256 public totalBalance;
    uint256 public rewardPool;
    
    // Temporary storage with cleanup strategy
    mapping(uint256 => address) public transactionSenders;
    mapping(uint256 => uint256) public transactionAmounts;
    mapping(uint256 => uint256) public transactionTimestamps;
    uint256 public transactionCount;
    uint256 public oldestTransactionIndex;  // Track what to clean
    
    constructor() {
        rewardPool = 1000000;
    }
    
    // Register a new user
    function registerUser(string memory username) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d6000, username) }
        require(!isRegistered[msg.sender], "Already registered");
        
        isRegistered[msg.sender] = true;
        usernames[msg.sender] = username;
        lastActivityTime[msg.sender] = block.timestamp;
        userIndex[msg.sender] = allUsers.length;
        allUsers.push(msg.sender);
        totalUsers++;
        
        // Give initial balance
        balances[msg.sender] = 1000;
        totalBalance += 1000;
    }
    
    // Remove user - optimized version with storage deletion
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00096000, user) }
        require(isRegistered[user], "User not registered");
        
        // Remove from array
        uint256 index = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,index)}
        if (index < allUsers.length - 1) {
            allUsers[index] = allUsers[allUsers.length - 1];
            userIndex[allUsers[index]] = index;
        }
        allUsers.pop();
        
        // Delete storage to get gas refunds
        delete isRegistered[user];        // Refund ~15,000 gas
        delete balances[user];            // Refund ~15,000 gas
        delete lastActivityTime[user];    // Refund ~15,000 gas
        delete usernames[user];           // Refund for string storage
        delete rewardPoints[user];        // Refund ~15,000 gas
        delete userIndex[user];           // Refund ~15,000 gas
        
        totalUsers--;
    }
    
    // Process transaction with automatic cleanup
    function processTransaction(address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c6001, amount) }
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // Store transaction details
        transactionSenders[transactionCount] = msg.sender;
        transactionAmounts[transactionCount] = amount;
        transactionTimestamps[transactionCount] = block.timestamp;
        transactionCount++;
        
        // Update balances
        balances[msg.sender] -= amount;
        balances[to] += amount;
        lastActivityTime[msg.sender] = block.timestamp;
        lastActivityTime[to] = block.timestamp;
        
        // Auto-cleanup old transactions if count exceeds threshold
        if (transactionCount - oldestTransactionIndex > 100) {
            _cleanupOldTransactions();
        }
    }
    
    // Internal function to cleanup old transactions
    function _cleanupOldTransactions() private {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060004, 0) }
        uint256 cleanupLimit = oldestTransactionIndex + 10;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,cleanupLimit)} // Clean 10 at a time
        
        for (uint256 i = oldestTransactionIndex; i < cleanupLimit && i < transactionCount - 50; i++) {
            // Delete storage to get gas refunds
            delete transactionSenders[i];     // Refund ~15,000 gas
            delete transactionAmounts[i];     // Refund ~15,000 gas
            delete transactionTimestamps[i];  // Refund ~15,000 gas
        }
        
        oldestTransactionIndex = cleanupLimit;
    }
    
    // Manual cleanup with gas refunds
    function clearOldTransactions(uint256 beforeIndex) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076000, beforeIndex) }
        require(beforeIndex <= transactionCount, "Invalid index");
        
        // Delete storage to get gas refunds
        for (uint256 i = oldestTransactionIndex; i < beforeIndex; i++) {
            delete transactionSenders[i];     // Gas refund
            delete transactionAmounts[i];     // Gas refund
            delete transactionTimestamps[i];  // Gas refund
        }
        
        if (beforeIndex > oldestTransactionIndex) {
            oldestTransactionIndex = beforeIndex;
        }
    }
    
    // Reset user rewards with storage deletion
    function resetUserRewards(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0000, 1037618708494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e6000, user) }
        delete rewardPoints[user];  // Delete for gas refund instead of setting to 0
    }
    
    // Batch cleanup of inactive users
    function cleanupInactiveUsers(address[] calldata users, uint256 inactivityThreshold) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0005, 209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a6002, inactivityThreshold) }
        uint256 thresholdTime = block.timestamp - inactivityThreshold;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,thresholdTime)}
        
        for (uint256 i = 0; i < users.length; i++) {
            if (lastActivityTime[users[i]] < thresholdTime && lastActivityTime[users[i]] > 0) {
                // Delete all user data for gas refunds
                delete isRegistered[users[i]];
                delete balances[users[i]];
                delete lastActivityTime[users[i]];
                delete usernames[users[i]];
                delete rewardPoints[users[i]];
                delete userIndex[users[i]];
            }
        }
    }
    
    // Get user data
    function getUserData(address user) public view returns (
        uint256 balance,
        bool registered,
        uint256 lastActivity,
        string memory username,
        uint256 rewards
    ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b6000, user) }
        return (
            balances[user],
            isRegistered[user],
            lastActivityTime[user],
            usernames[user],
            rewardPoints[user]
        );
    }
    
    // Get active transaction count (excludes cleaned up ones)
    function getActiveTransactionCount() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080004, 0) }
        return transactionCount - oldestTransactionIndex;
    }
}