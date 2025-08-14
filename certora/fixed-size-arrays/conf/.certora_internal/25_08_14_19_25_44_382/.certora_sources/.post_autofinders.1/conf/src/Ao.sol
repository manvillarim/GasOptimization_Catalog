// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Using Fixed-Size Arrays (Optimized)
 * This contract demonstrates efficient memory management
 * by using fixed-size arrays with predetermined allocation
 */
contract Ao {
    // Storage variables for user management
    mapping(address => uint256) public balances;
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public lastActivityTime;
    mapping(address => uint256) public rewardPoints;
    
    // Fixed-size arrays - efficient memory allocation
    uint256 constant MAX_USERS = 1000;
    uint256 constant MAX_TRANSACTIONS = 10000;
    
    address[MAX_USERS] public allUsers;
    uint256[MAX_USERS] public userRewards;
    uint256[MAX_TRANSACTIONS] public transactionAmounts;
    address[MAX_TRANSACTIONS] public transactionSenders;
    uint256[MAX_TRANSACTIONS] public transactionTimestamps;
    
    // Mapping for user index tracking
    mapping(address => uint256) public userIndex;
    
    // Contract state variables
    uint256 public totalUsers;
    uint256 public totalBalance;
    uint256 public rewardPool;
    uint256 public transactionCount;
    
    // Track current lengths for fixed arrays
    uint256 public currentUserCount;
    uint256 public currentTransactionCount;
    
    constructor() {
        rewardPool = 1000000;
    }
    
    // Register a new user - uses fixed array with bounds checking
    function registerUser() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0004, 0) }
        require(!isRegistered[msg.sender], "Already registered");
        require(currentUserCount < MAX_USERS, "Maximum users reached");
        
        isRegistered[msg.sender] = true;
        lastActivityTime[msg.sender] = block.timestamp;
        userIndex[msg.sender] = currentUserCount;
        
        // Fixed array assignment - gas efficient
        allUsers[currentUserCount] = msg.sender;
        userRewards[currentUserCount] = 0;
        
        currentUserCount++;
        totalUsers++;
        
        // Give initial balance
        balances[msg.sender] = 1000;
        totalBalance += 1000;
    }
    
    // Remove user - fixed array manipulation
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00096000, user) }
        require(isRegistered[user], "User not registered");
        
        // Subtract balance from total
        totalBalance -= balances[user];
        
        // Remove from fixed arrays - efficient operations
        uint256 index = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,index)}
        if (index < currentUserCount - 1) {
            allUsers[index] = allUsers[currentUserCount - 1];
            userRewards[index] = userRewards[currentUserCount - 1];
            userIndex[allUsers[index]] = index;
        }
        
        // Clear the last position
        allUsers[currentUserCount - 1] = address(0);
        userRewards[currentUserCount - 1] = 0;
        currentUserCount--;
        
        // Clean up mappings with delete for gas refunds
        delete isRegistered[user];
        delete balances[user];
        delete lastActivityTime[user];
        delete rewardPoints[user];
        delete userIndex[user];
        
        totalUsers--;
    }
    
    // Process transaction - stores in fixed arrays
    function processTransaction(address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c6001, amount) }
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(isRegistered[msg.sender] && isRegistered[to], "Users must be registered");
        require(currentTransactionCount < MAX_TRANSACTIONS, "Transaction limit reached");
        
        // Store in fixed arrays - efficient assignment
        transactionSenders[currentTransactionCount] = msg.sender;
        transactionAmounts[currentTransactionCount] = amount;
        transactionTimestamps[currentTransactionCount] = block.timestamp;
        currentTransactionCount++;
        transactionCount++;
        
        // Update balances
        balances[msg.sender] -= amount;
        balances[to] += amount;
        lastActivityTime[msg.sender] = block.timestamp;
        lastActivityTime[to] = block.timestamp;
        
        // Award reward points
        rewardPoints[msg.sender] += amount / 100;
    }
    
    // Add multiple transactions - efficient fixed array operations
    function batchProcessTransactions(
        address[] calldata recipients,
        uint256[] calldata amounts
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0000, 1037618708494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0005, 1690) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e6102, amounts.offset) }
        require(recipients.length == amounts.length, "Array length mismatch");
        require(currentTransactionCount + recipients.length <= MAX_TRANSACTIONS, 
                "Would exceed transaction limit");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            
            // Fixed array assignment - gas efficient
            transactionSenders[currentTransactionCount + i] = msg.sender;
            transactionAmounts[currentTransactionCount + i] = amounts[i];
            transactionTimestamps[currentTransactionCount + i] = block.timestamp;
            
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
            rewardPoints[msg.sender] += amounts[i] / 100;
        }
        
        currentTransactionCount += recipients.length;
        transactionCount += recipients.length;
        lastActivityTime[msg.sender] = block.timestamp;
    }
    
    // Get transaction history - efficient fixed array access
    function getTransactionHistory(uint256 start, uint256 end) 
        public view returns (
            address[] memory senders,
            uint256[] memory amounts,
            uint256[] memory timestamps
        ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0000, 1037618708495) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f6001, end) }
        require(start <= end && end <= currentTransactionCount, "Invalid range");
        
        uint256 length = end - start;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,length)}
        senders = new address[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020003,0)}
        amounts = new uint256[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020004,0)}
        timestamps = new uint256[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020005,0)}
        
        for (uint256 i = 0; i < length; i++) {
            senders[i] = transactionSenders[start + i];address certora_local7 = senders[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,certora_local7)}
            amounts[i] = transactionAmounts[start + i];uint256 certora_local8 = amounts[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,certora_local8)}
            timestamps[i] = transactionTimestamps[start + i];uint256 certora_local9 = timestamps[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,certora_local9)}
        }
    }
    
    // Get active users - returns only populated portion of fixed array
    function getActiveUsers() public view returns (address[] memory activeUsers) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080004, 0) }
        activeUsers = new address[](currentUserCount);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020006,0)}
        for (uint256 i = 0; i < currentUserCount; i++) {
            activeUsers[i] = allUsers[i];address certora_local10 = activeUsers[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,certora_local10)}
        }
    }
    
    // Clear old transactions - efficient fixed array cleanup
    function clearOldTransactions(uint256 beforeIndex) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076000, beforeIndex) }
        require(beforeIndex <= currentTransactionCount, "Invalid index");
        
        for (uint256 i = 0; i < beforeIndex; i++) {
            delete transactionSenders[i];
            delete transactionAmounts[i];
            delete transactionTimestamps[i];
        }
        
        // Shift remaining transactions to the beginning
        for (uint256 i = beforeIndex; i < currentTransactionCount; i++) {
            transactionSenders[i - beforeIndex] = transactionSenders[i];
            transactionAmounts[i - beforeIndex] = transactionAmounts[i];
            transactionTimestamps[i - beforeIndex] = transactionTimestamps[i];
            
            // Clear old positions
            delete transactionSenders[i];
            delete transactionAmounts[i];
            delete transactionTimestamps[i];
        }
        
        currentTransactionCount -= beforeIndex;
    }
    
    // Get capacity information
    function getCapacityInfo() public view returns (
        uint256 maxUsers,
        uint256 currentUsers,
        uint256 maxTransactions,
        uint256 currentTransactions
    ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) }
        return (MAX_USERS, currentUserCount, MAX_TRANSACTIONS, currentTransactionCount);
    }
    
    // Get user stats
    function getUserStats() public view returns (uint256 userCount, uint256 txCount) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0004, 0) }
        return (currentUserCount, currentTransactionCount);
    }
    
    // Get total users count
    function getTotalUsers() external view returns (uint256) {
        return currentUserCount;
    }
    
    // Get total balance
    function getTotalBalance() external view returns (uint256) {
        return totalBalance;
    }
    
    // Get transaction count
    function getTransactionCount() external view returns (uint256) {
        return currentTransactionCount;
    }
    
    // Get users array length (effective length)
    function getUsersLength() external view returns (uint256) {
        return currentUserCount;
    }
}