// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - With Storage Cleanup Optimization (CORRECTED)
 * This contract demonstrates efficient storage management
 * by deleting unused storage variables to get gas refunds
 */
contract Ao {
    // Storage variables for user management
    mapping(address => uint256) public balances;
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public lastActivityTime;
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
    function registerUser() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0004, 0) }
        require(!isRegistered[msg.sender], "Already registered");
        
        isRegistered[msg.sender] = true;
        lastActivityTime[msg.sender] = block.timestamp;
        userIndex[msg.sender] = allUsers.length;
        allUsers.push(msg.sender);
        totalUsers++;
        
        // Give initial balance
        balances[msg.sender] = 1000;
        totalBalance += 1000;
    }
    
    // Remove user - optimized version with storage deletion
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b6000, user) }
        require(isRegistered[user], "User not registered");
        
        // Subtract balance from total before deleting
        totalBalance -= balances[user];
        
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
        delete rewardPoints[user];        // Refund ~15,000 gas
        delete userIndex[user];           // Refund ~15,000 gas
        
        totalUsers--;
    }
    
    // Process transaction with automatic cleanup
    function processTransaction(address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0000, 1037618708494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e6001, amount) }
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
           // _cleanupOldTransactions();
        }
    }
    
    // Internal function to cleanup old transactions
    function _cleanupOldTransactions() private {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080004, 0) }
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
    function clearOldTransactions(uint256 beforeIndex) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00096000, beforeIndex) }
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
    function resetUserRewards(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00100000, 1037618708496) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00100001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00100005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00106000, user) }
        delete rewardPoints[user];  // Delete for gas refund instead of setting to 0
    }
    
    // CORRECTED: Batch cleanup of inactive users with proper array management
    function cleanupInactiveUsers(address[] calldata users, uint256 inactivityThreshold) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0005, 209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c6002, inactivityThreshold) }
        uint256 thresholdTime = block.timestamp - inactivityThreshold;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,thresholdTime)}
        
        // Process in reverse order to avoid index shifting issues
        for (uint256 i = users.length; i > 0; i--) {
            address userToRemove = users[i - 1];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,userToRemove)}
            
            // Check if user is inactive and registered
            if (isRegistered[userToRemove] && 
                lastActivityTime[userToRemove] < thresholdTime && 
                lastActivityTime[userToRemove] > 0) {
                
                // Subtract balance from total before deleting
                totalBalance -= balances[userToRemove];
                
                // Remove from array
                uint256 index = userIndex[userToRemove];
                if (index < allUsers.length - 1) {
                    address lastUser = allUsers[allUsers.length - 1];
                    allUsers[index] = lastUser;
                    userIndex[lastUser] = index;
                }
                allUsers.pop();
                
                // Delete all user data for gas refunds
                delete isRegistered[userToRemove];
                delete balances[userToRemove];
                delete lastActivityTime[userToRemove];
                delete rewardPoints[userToRemove];
                delete userIndex[userToRemove];
                
                // Decrement total users
                totalUsers--;
            }
        }
    }
    
    // Get user data
    function getUserData(address user) public view returns (
        uint256 balance,
        bool registered,
        uint256 lastActivity,
        uint256 rewards
    ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0000, 1037618708495) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f6000, user) }
        return (
            balances[user],
            isRegistered[user],
            lastActivityTime[user],
            rewardPoints[user]
        );
    }
    
    // Get active transaction count (excludes cleaned up ones)
    function getActiveTransactionCount() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) }
        return transactionCount - oldestTransactionIndex;
    }
}