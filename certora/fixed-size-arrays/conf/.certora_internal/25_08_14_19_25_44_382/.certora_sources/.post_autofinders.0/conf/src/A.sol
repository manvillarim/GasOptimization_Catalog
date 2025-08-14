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
    function registerUser() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
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
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, user) }
        require(isRegistered[user], "User not registered");
        
        // Subtract balance from total
        totalBalance -= balances[user];
        
        // Remove from dynamic arrays - expensive operations
        uint256 index = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,index)}
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
    function processTransaction(address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036001, amount) }
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
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1690) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056102, amounts.offset) }
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
        ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00066001, end) }
        require(start <= end && end <= transactionCount, "Invalid range");
        
        uint256 length = end - start;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,length)}
        senders = new address[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020003,0)}
        amounts = new uint256[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020004,0)}
        timestamps = new uint256[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020005,0)}
        
        for (uint256 i = 0; i < length; i++) {
            senders[i] = transactionSenders[start + i];address certora_local6 = senders[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,certora_local6)}
            amounts[i] = transactionAmounts[start + i];uint256 certora_local7 = amounts[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,certora_local7)}
            timestamps[i] = transactionTimestamps[start + i];uint256 certora_local8 = timestamps[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,certora_local8)}
        }
    }
    
    // Get all users - returns entire dynamic array
    function getAllUsers() public view returns (address[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        return allUsers;
    }
    
    // Get user stats
    function getUserStats() public view returns (uint256 userCount, uint256 txCount) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040004, 0) }
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