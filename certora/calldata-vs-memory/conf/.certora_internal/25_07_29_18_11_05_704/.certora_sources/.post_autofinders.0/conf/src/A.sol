// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Using Memory Parameters
 * This contract demonstrates the use of memory for function parameters
 * which requires copying data from calldata to memory, consuming more gas
 */
contract A {
    // Struct definitions
    struct User {
        uint256 id;
        uint256 balance;
        uint256 lastActivity;
        bool isActive;
    }
    
    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
    }
    
    // State variables
    mapping(uint256 => User) public users;
    mapping(uint256 => Transaction) public transactions;
    uint256 public totalUsers;
    uint256 public totalTransactions;
    uint256 public totalBalance;
    
    // Events
    event UsersProcessed(uint256 count);
    event TransactionsProcessed(uint256 count);
    event DataProcessed(uint256 sum, uint256 average);
    
    // Process array of numbers - using memory
    function processNumbers(uint256[] memory numbers) external pure returns (uint256 sum, uint256 average) {
        require(numbers.length > 0, "Empty array");
        
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,sum)}
        }
        
        average = sum / numbers.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,average)}
        
        return (sum, average);
    }
    
    // Process user data - using memory
    function processUser(User memory user) external returns (bool) {
        require(user.id > 0, "Invalid user ID");
        require(user.balance <= 1000000, "Balance too high");
        
        users[user.id] = user;
        
        if (user.isActive) {
            totalBalance += user.balance;
            totalUsers++;
        }
        
        return true;
    }
    
    // Batch process users - using memory
    function batchProcessUsers(User[] memory userList) external returns (uint256 processed) {
        for (uint256 i = 0; i < userList.length; i++) {
            if (userList[i].id > 0 && userList[i].balance <= 1000000) {
                users[userList[i].id] = userList[i];
                
                if (userList[i].isActive) {
                    totalBalance += userList[i].balance;
                    totalUsers++;
                }
                
                processed++;
            }
        }
        
        emit UsersProcessed(processed);
        return processed;
    }
    
    // Process transaction - using memory
    function processTransaction(Transaction memory txn) external returns (uint256) {
        require(txn.from != address(0), "Invalid from address");
        require(txn.to != address(0), "Invalid to address");
        require(txn.amount > 0, "Invalid amount");
        
        totalTransactions++;
        transactions[totalTransactions] = txn;
        
        return totalTransactions;
    }
    
    // Batch process transactions - using memory
    function batchProcessTransactions(Transaction[] memory txnList) external returns (uint256[] memory ids) {
        ids = new uint256[](txnList.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020002,0)}
        
        for (uint256 i = 0; i < txnList.length; i++) {
            if (txnList[i].from != address(0) && 
                txnList[i].to != address(0) && 
                txnList[i].amount > 0) {
                
                totalTransactions++;
                transactions[totalTransactions] = txnList[i];
                ids[i] = totalTransactions;
            }
        }
        
        emit TransactionsProcessed(txnList.length);
        return ids;
    }
    
    // Complex data processing - using memory
    function analyzeData(
        uint256[] memory values,
        User[] memory userList,
        Transaction[] memory txnList
    ) external returns (
        uint256 sumValues,
        uint256 activeUsers,
        uint256 totalTxnAmount
    ) {
        // Process values
        for (uint256 i = 0; i < values.length; i++) {
            sumValues += values[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,sumValues)}
        }
        
        // Count active users
        for (uint256 j = 0; j < userList.length; j++) {
            if (userList[j].isActive) {
                activeUsers++;
            }
        }
        
        // Sum transaction amounts
        for (uint256 k = 0; k < txnList.length; k++) {
            totalTxnAmount += txnList[k].amount;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,totalTxnAmount)}
        }
        
        emit DataProcessed(sumValues, totalTxnAmount);
        
        return (sumValues, activeUsers, totalTxnAmount);
    }
    
    // Get user data
    function getUser(uint256 userId) external view returns (User memory) {
        return users[userId];
    }
    
    // Get transaction data
    function getTransaction(uint256 txnId) external view returns (Transaction memory) {
        return transactions[txnId];
    }
}