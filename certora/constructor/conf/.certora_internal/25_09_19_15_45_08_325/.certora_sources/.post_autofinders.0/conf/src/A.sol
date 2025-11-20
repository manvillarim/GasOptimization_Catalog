// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Without Storage Cleanup (but with same functionality)
 * This contract demonstrates inefficient storage management
 * by not deleting unused storage variables
 */
contract A {
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
    
    // Temporary storage that accumulates over time
    mapping(uint256 => address) public transactionSenders;
    mapping(uint256 => uint256) public transactionAmounts;
    mapping(uint256 => uint256) public transactionTimestamps;
    uint256 public transactionCount;
    uint256 public oldestTransactionIndex;  // Added to match Ao's interface
    
    constructor() {
        rewardPool = 1000000;
    }
    
    // Register a new user
    function registerUser() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040004, 0) }
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
    
    // Remove user - inefficient version
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026000, user) }
        require(isRegistered[user], "User not registered");
        
        // Subtract balance from total before setting to 0
        totalBalance -= balances[user];
        
        // Remove from array but don't clean up storage
        uint256 index = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,index)}
        if (index < allUsers.length - 1) {
            allUsers[index] = allUsers[allUsers.length - 1];
            userIndex[allUsers[index]] = index;
        }
        allUsers.pop();
        
        // Just set values to 0/false instead of deleting
        isRegistered[user] = false;
        balances[user] = 0;
        lastActivityTime[user] = 0;
        rewardPoints[user] = 0;
        userIndex[user] = 0;
        
        totalUsers--;
    }
    
    // Process transaction - stores unnecessary history
    function processTransaction(address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056001, amount) }
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // Store transaction details (accumulates forever)
        transactionSenders[transactionCount] = msg.sender;
        transactionAmounts[transactionCount] = amount;
        transactionTimestamps[transactionCount] = block.timestamp;
        transactionCount++;
        
        // Update balances
        balances[msg.sender] -= amount;
        balances[to] += amount;
        lastActivityTime[msg.sender] = block.timestamp;
        lastActivityTime[to] = block.timestamp;
    }
    
    // Clear old transactions - inefficient version
    function clearOldTransactions(uint256 beforeIndex) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, beforeIndex) }
        require(beforeIndex <= transactionCount, "Invalid index");
        
        // Just sets to zero values instead of deleting
        for (uint256 i = oldestTransactionIndex; i < beforeIndex; i++) {
            transactionSenders[i] = address(0);
            transactionAmounts[i] = 0;
            transactionTimestamps[i] = 0;
        }
        
        if (beforeIndex > oldestTransactionIndex) {
            oldestTransactionIndex = beforeIndex;
        }
    }
    
    // Reset user rewards - inefficient version
    function resetUserRewards(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076000, user) }
        rewardPoints[user] = 0;  // Just sets to 0 instead of delete
    }
    
    // Batch cleanup of inactive users - inefficient version (no delete)
    function cleanupInactiveUsers(address[] calldata users, uint256 inactivityThreshold) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036002, inactivityThreshold) }
        uint256 thresholdTime = block.timestamp - inactivityThreshold;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,thresholdTime)}
        
        // Process in reverse order to avoid index shifting issues
        for (uint256 i = users.length; i > 0; i--) {
            address userToRemove = users[i - 1];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,userToRemove)}
            
            // Check if user is inactive and registered
            if (isRegistered[userToRemove] && 
                lastActivityTime[userToRemove] < thresholdTime && 
                lastActivityTime[userToRemove] > 0) {
                
                // Subtract balance from total before setting to 0
                totalBalance -= balances[userToRemove];
                
                // Remove from array
                uint256 index = userIndex[userToRemove];
                if (index < allUsers.length - 1) {
                    address lastUser = allUsers[allUsers.length - 1];
                    allUsers[index] = lastUser;
                    userIndex[lastUser] = index;
                }
                allUsers.pop();
                
                // Set all user data to 0/false (no delete for gas refunds)
                isRegistered[userToRemove] = false;
                balances[userToRemove] = 0;
                lastActivityTime[userToRemove] = 0;
                rewardPoints[userToRemove] = 0;
                userIndex[userToRemove] = 0;
                
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
    ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00066000, user) }
        return (
            balances[user],
            isRegistered[user],
            lastActivityTime[user],
            rewardPoints[user]
        );
    }
    
    // Get active transaction count (excludes cleaned up ones)
    function getActiveTransactionCount() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        return transactionCount - oldestTransactionIndex;
    }
}