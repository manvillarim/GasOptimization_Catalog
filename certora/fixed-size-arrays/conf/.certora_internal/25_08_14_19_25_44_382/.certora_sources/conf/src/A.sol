// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Using Dynamic Arrays (Inefficient)
 * This contract demonstrates inefficient memory management
 * by using dynamic arrays with runtime allocation overhead
 */
contract A {
    // Storage variables for user management
    mapping(address => uint256) public balances;
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public lastActivityTime;
    mapping(address => uint256) public rewardPoints;
    
    // Dynamic arrays - inefficient memory allocation
    address[] public allUsers;
    uint256[] public userRewards;
    uint256[] public transactionAmounts;
    address[] public transactionSenders;
    uint256[] public transactionTimestamps;
    
    // Mapping for user index tracking
    mapping(address => uint256) public userIndex;
    
    // Contract state variables
    uint256 public totalUsers;
    uint256 public totalBalance;
    uint256 public rewardPool;
    uint256 public transactionCount;
    
    constructor() {
        rewardPool = 1000000;
    }
    
    // Register a new user - uses dynamic array push
    function registerUser() public {
        require(!isRegistered[msg.sender], "Already registered");
        
        isRegistered[msg.sender] = true;
        lastActivityTime[msg.sender] = block.timestamp;
        userIndex[msg.sender] = allUsers.length;
        
        // Dynamic array operations - gas expensive
        allUsers.push(msg.sender);
        userRewards.push(0);
        
        totalUsers++;
        
        // Give initial balance
        balances[msg.sender] = 1000;
        totalBalance += 1000;
    }
    
    // Remove user - dynamic array manipulation
    function removeUser(address user) public {
        require(isRegistered[user], "User not registered");
        
        // Subtract balance from total
        totalBalance -= balances[user];
        
        // Remove from dynamic arrays - expensive operations
        uint256 index = userIndex[user];
        if (index < allUsers.length - 1) {
            allUsers[index] = allUsers[allUsers.length - 1];
            userRewards[index] = userRewards[userRewards.length - 1];
            userIndex[allUsers[index]] = index;
        }
        allUsers.pop();
        userRewards.pop();
        
        // Clean up mappings
        delete isRegistered[user];
        delete balances[user];
        delete lastActivityTime[user];
        delete rewardPoints[user];
        delete userIndex[user];
        
        totalUsers--;
    }
    
    // Process transaction - stores in dynamic arrays
    function processTransaction(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(isRegistered[msg.sender] && isRegistered[to], "Users must be registered");
        
        // Store in dynamic arrays - expensive push operations
        transactionSenders.push(msg.sender);
        transactionAmounts.push(amount);
        transactionTimestamps.push(block.timestamp);
        transactionCount++;
        
        // Update balances
        balances[msg.sender] -= amount;
        balances[to] += amount;
        lastActivityTime[msg.sender] = block.timestamp;
        lastActivityTime[to] = block.timestamp;
        
        // Award reward points
        rewardPoints[msg.sender] += amount / 100;
    }
    
    // Add multiple transactions - multiple dynamic allocations
    function batchProcessTransactions(
        address[] calldata recipients,
        uint256[] calldata amounts
    ) public {
        require(recipients.length == amounts.length, "Array length mismatch");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            
            // Each iteration involves dynamic array push - gas expensive
            transactionSenders.push(msg.sender);
            transactionAmounts.push(amounts[i]);
            transactionTimestamps.push(block.timestamp);
            
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
            rewardPoints[msg.sender] += amounts[i] / 100;
        }
        
        transactionCount += recipients.length;
        lastActivityTime[msg.sender] = block.timestamp;
    }
    
    // Get transaction history - returns dynamic array data
    function getTransactionHistory(uint256 start, uint256 end) 
        public view returns (
            address[] memory senders,
            uint256[] memory amounts,
            uint256[] memory timestamps
        ) {
        require(start <= end && end <= transactionCount, "Invalid range");
        
        uint256 length = end - start;
        senders = new address[](length);
        amounts = new uint256[](length);
        timestamps = new uint256[](length);
        
        for (uint256 i = 0; i < length; i++) {
            senders[i] = transactionSenders[start + i];
            amounts[i] = transactionAmounts[start + i];
            timestamps[i] = transactionTimestamps[start + i];
        }
    }
    
    // Get all users - returns entire dynamic array
    function getAllUsers() public view returns (address[] memory) {
        return allUsers;
    }
    
    // Get user stats
    function getUserStats() public view returns (uint256 userCount, uint256 txCount) {
        return (allUsers.length, transactionCount);
    }
    
    // Get total users count
    function getTotalUsers() external view returns (uint256) {
        return allUsers.length;
    }
    
    // Get total balance
    function getTotalBalance() external view returns (uint256) {
        return totalBalance;
    }
    
    // Get transaction count
    function getTransactionCount() external view returns (uint256) {
        return transactionCount;
    }
    
    // Get users array length
    function getUsersLength() external view returns (uint256) {
        return allUsers.length;
    }
}