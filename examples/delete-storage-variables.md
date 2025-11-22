# 11. Delete Unused Storage Variables

This transformation uses the `delete` keyword to clear storage variables that are no longer needed. The `delete` operation provides gas refunds when freeing storage slots, making it more gas-efficient than setting values to zero. This is particularly important for mappings, structs, and arrays where clearing data can reclaim storage costs.

## Example

### Original (Without Storage Cleanup)
```solidity
contract NoCleanup {
    mapping(address => uint) public balances;
    mapping(address => bool) public isActive;
    
    function removeUser(address user) public {
        balances[user] = 0;      // Sets to zero, no gas refund
        isActive[user] = false;  // Sets to false, no gas refund
    }
    
    function resetBalance(address user) public {
        balances[user] = 0;  // Manual reset without refund
    }
}
```

### Optimised (With Storage Cleanup)
```solidity
contract WithCleanup {
    mapping(address => uint) public balances;
    mapping(address => bool) public isActive;
    
    function removeUser(address user) public {
        delete balances[user];   // Clears storage and provides gas refund
        delete isActive[user];   // Clears storage and provides gas refund
    }
    
    function resetBalance(address user) public {
        delete balances[user];  // Delete operation provides gas refund
    }
}
```

## Gas Savings

Using `delete` instead of manual zero assignment provides gas refunds when clearing storage, reducing the net cost of storage operations and keeping the blockchain state more compact.