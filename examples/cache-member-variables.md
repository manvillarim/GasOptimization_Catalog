# 26. Cache array member variables

This transformation caches frequently accessed array members in local variables within loops. When accessing the same array element multiple times, storing it in a local variable reduces the number of array access operations and associated gas costs.

## Example

### Repeated Array Member Access

```solidity
contract RepeatedArrayAccess {
    struct User {
        string name;
        uint balance;
        bool active;
        uint[] transactions;
    }
    
    User[] public users;
    
    function processUsers() public {
        for(uint i = 0; i < users.length; i++) {
            // Multiple accesses to same array member
            if(users[i].active && users[i].balance > 100) {
                users[i].balance = users[i].balance - 10;
                
                // More operations on same member
                if(users[i].balance < 50) {
                    users[i].active = false;
                }
                
                users[i].transactions.push(block.timestamp);
            }
        }
    }
}
```
### Optimized Cached Array Members

```solidity
contract CachedArrayMembers {
    struct User {
        string name;
        uint balance;
        bool active;
        uint[] transactions;
    }
    
    User[] public users;
    
    function processUsers() public {
        for(uint i = 0; i < users.length; i++) {
            // Cache array member in local variable
            User storage user = users[i];
            
            if(user.active && user.balance > 100) {
                user.balance = user.balance - 10;
                
                // Use cached reference
                if(user.balance < 50) {
                    user.active = false;
                }
                
                user.transactions.push(block.timestamp);
            }
        }
    }
}
```