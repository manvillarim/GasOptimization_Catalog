# 12. Delete unused storage variables

This transformation removes storage variables that are no longer needed using the delete keyword. Deleting storage variables provides gas refunds and helps keep the blockchain compact by freeing up storage space.

## Example

### Without Storage Cleanup
```solidity
contract NoCleanup {
    mapping(address => uint) public balances;
    address[] public users;
    
    function removeUser(address user) public {
        // Remove from array but don't delete storage
        for(uint i = 0; i < users.length; i++) {
            if(users[i] == user) {
                users[i] = users[users.length - 1];
                users.pop();
                break;
            }
        }
        balances[user] = 0; // Setting to 0 instead of delete
    }
}
```
### Optimized Storage Cleanup

```solidity
contract WithCleanup {
    mapping(address => uint) public balances;
    address[] public users;
    
    function removeUser(address user) public {
        // Remove from array and delete storage
        for(uint i = 0; i < users.length; i++) {
            if(users[i] == user) {
                users[i] = users[users.length - 1];
                users.pop();
                break;
            }
        }
        delete balances[user]; // Delete provides gas refund
    }
}
```