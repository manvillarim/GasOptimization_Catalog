// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract Ao - Fixed-Size Arrays Implementation
 * @dev This contract demonstrates the use of fixed-size arrays which are more gas-efficient
 * due to predetermined memory allocation. No dynamic memory management overhead is required,
 * resulting in significant gas savings and predictable storage costs.
 */
contract Ao {
    // Fixed-size arrays with predetermined capacity (gas-efficient)
    uint256[100] public balances;           // Fixed array of 100 balances
    address[50] public users;               // Fixed array of 50 user addresses
    bool[50] public permissions;            // Fixed array of 50 permission flags
    string[50] public names;                // Fixed array of 50 names
    bytes32[200] public hashes;             // Fixed array of 200 hash values
    
    // Length trackers for fixed arrays (more efficient than dynamic length management)
    uint256 public balancesLength;          // Current number of balances
    uint256 public usersLength;             // Current number of users
    uint256 public hashesLength;            // Current number of hashes
    
    // Fixed-size array for complex data structures
    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
    }
    
    Transaction[1000] public transactions;  // Fixed array of 1000 transactions
    uint256 public transactionsLength;      // Current number of transactions
    
    // Mapping to track user indices in fixed arrays
    mapping(address => uint256) public userIndex;
    mapping(address => bool) public userExists;
    
    /**
     * @dev Add multiple balances using fixed-size array operations
     * More gas-efficient as no dynamic allocation is required
     */
    function addBalances(uint256[] memory newBalances) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0000, 1037618708494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e6000, newBalances) }
        require(
            balancesLength + newBalances.length <= balances.length,
            "Exceeds maximum balance capacity"
        );
        
        for (uint256 i = 0; i < newBalances.length; i++) {
            balances[balancesLength + i] = newBalances[i];  // Direct assignment, no push overhead
        }
        balancesLength += newBalances.length;  // Single length update
    }
    
    /**
     * @dev Add a new user with fixed-size array management
     * Demonstrates gas efficiency of fixed-size array operations
     */
    function addUser(address user, string memory name, bool permission) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d6002, permission) }
        require(usersLength < users.length, "Maximum user capacity reached");
        require(!userExists[user], "User already exists");
        
        // Direct assignment to fixed positions (gas-efficient)
        uint256 index = usersLength;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,index)}
        users[index] = user;                    // No dynamic allocation
        names[index] = name;                    // No dynamic allocation
        permissions[index] = permission;        // No dynamic allocation
        
        // Update tracking variables
        userIndex[user] = index;
        userExists[user] = true;
        usersLength++;  // Single increment operation
    }
    
    /**
     * @dev Remove user by replacing with last element (gas-efficient)
     * Avoids expensive shifting operations required in dynamic arrays
     */
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b6000, user) }
        require(userExists[user], "User does not exist");
        
        uint256 indexToRemove = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,indexToRemove)}
        uint256 lastIndex = usersLength - 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,lastIndex)}
        
        // Replace with last element if not the last element
        if (indexToRemove != lastIndex) {
            address lastUser = users[lastIndex];
            
            // Move last element to removed position
            users[indexToRemove] = lastUser;
            names[indexToRemove] = names[lastIndex];
            permissions[indexToRemove] = permissions[lastIndex];
            
            // Update moved user's index
            userIndex[lastUser] = indexToRemove;
        }
        
        // Clear last position and update tracking
        delete users[lastIndex];
        delete names[lastIndex];
        delete permissions[lastIndex];
        delete userIndex[user];
        userExists[user] = false;
        usersLength--;
    }
    
    /**
     * @dev Add transaction with fixed-size array efficiency
     * Demonstrates gas savings of predetermined memory allocation
     */
    function addTransaction(address from, address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00130000, 1037618708499) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00130001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00130005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00136002, amount) }
        require(transactionsLength < transactions.length, "Transaction capacity exceeded");
        
        // Direct assignment to fixed position (gas-efficient)
        transactions[transactionsLength] = Transaction({
            from: from,
            to: to,
            amount: amount,
            timestamp: block.timestamp
        });
        transactionsLength++;  // Single increment
    }
    
    /**
     * @dev Batch add transactions using fixed-size arrays
     * Shows gas efficiency of batch operations with fixed arrays
     */
    function addMultipleTransactions(
        address[] memory fromAddresses,
        address[] memory toAddresses,
        uint256[] memory amounts
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00096002, amounts) }
        require(
            fromAddresses.length == toAddresses.length && 
            toAddresses.length == amounts.length,
            "Array lengths must match"
        );
        require(
            transactionsLength + fromAddresses.length <= transactions.length,
            "Transaction capacity exceeded"
        );
        
        for (uint256 i = 0; i < fromAddresses.length; i++) {
            // Direct assignment, no dynamic allocation overhead
            transactions[transactionsLength + i] = Transaction({
                from: fromAddresses[i],
                to: toAddresses[i],
                amount: amounts[i],
                timestamp: block.timestamp
            });
        }
        transactionsLength += fromAddresses.length;  // Single batch update
    }
    
    /**
     * @dev Get balances within current length (gas-efficient)
     * Returns only used portion of fixed array
     */
    function getAllBalances() public view returns (uint256[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) }
        uint256[] memory result = new uint256[](balancesLength);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010004,0)}
        for (uint256 i = 0; i < balancesLength; i++) {
            result[i] = balances[i];uint256 certora_local10 = result[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,certora_local10)}
        }
        return result;
    }
    
    /**
     * @dev Get user information by address (O(1) lookup)
     * More efficient than searching through dynamic arrays
     */
    function getUserInfo(address user) public view returns (string memory name, bool permission) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c6000, user) }
        require(userExists[user], "User not found");
        
        uint256 index = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,index)}
        return (names[index], permissions[index]);
    }
    
    /**
     * @dev Search for transactions by sender with fixed-size array
     * Still requires iteration but with predictable gas costs
     */
    function getTransactionsBySender(address sender) public view returns (Transaction[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00086000, sender) }
        // First pass: count matching transactions within current length
        uint256 count = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,count)}
        for (uint256 i = 0; i < transactionsLength; i++) {
            if (transactions[i].from == sender) {
                count++;
            }
        }
        
        // Create result array with exact size needed
        Transaction[] memory result = new Transaction[](count);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010007,0)}
        uint256 resultIndex = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,resultIndex)}
        
        // Second pass: populate results within current length
        for (uint256 i = 0; i < transactionsLength; i++) {
            if (transactions[i].from == sender) {
                result[resultIndex] = transactions[i];
                resultIndex++;
            }
        }
        
        return result;
    }
    
    /**
     * @dev Clear all data using fixed-size array reset
     * More predictable gas cost than dynamic array clearing
     */
    function clearAllData() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00110000, 1037618708497) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00110001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00110004, 0) }
        // Reset length counters (gas-efficient)
        balancesLength = 0;
        usersLength = 0;
        hashesLength = 0;
        transactionsLength = 0;
        
        // Note: Individual elements don't need to be cleared immediately
        // They will be overwritten when new data is added
        // This is more gas-efficient than clearing each element
    }
    
    /**
     * @dev Get current usage and capacity information
     * Provides transparency about fixed array utilization
     */
    function getArrayInfo() public view returns (
        uint256 currentBalances,
        uint256 maxBalances,
        uint256 currentUsers,
        uint256 maxUsers,
        uint256 currentTransactions,
        uint256 maxTransactions
    ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00100000, 1037618708496) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00100001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00100004, 0) }
        return (
            balancesLength,
            balances.length,
            usersLength,
            users.length,
            transactionsLength,
            transactions.length
        );
    }
    
    /**
     * @dev Check if there's capacity for more elements
     * Helps prevent transaction failures due to capacity limits
     */
    function hasCapacity(
        uint256 additionalBalances,
        uint256 additionalUsers,
        uint256 additionalTransactions
    ) public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00120000, 1037618708498) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00120001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00120005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00126002, additionalTransactions) }
        return (
            balancesLength + additionalBalances <= balances.length &&
            usersLength + additionalUsers <= users.length &&
            transactionsLength + additionalTransactions <= transactions.length
        );
    }
    
    /**
     * @dev Get specific range of elements (gas-efficient partial access)
     * Allows efficient access to portions of the fixed array
     */
    function getBalanceRange(uint256 start, uint256 end) public view returns (uint256[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0000, 1037618708495) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f6001, end) }
        require(start <= end && end <= balancesLength, "Invalid range");
        
        uint256[] memory result = new uint256[](end - start);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010009,0)}
        for (uint256 i = 0; i < end - start; i++) {
            result[i] = balances[start + i];uint256 certora_local11 = result[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,certora_local11)}
        }
        return result;
    }
}