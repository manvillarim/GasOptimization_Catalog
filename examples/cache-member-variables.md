# 24. Cache Array Member Variables

This transformation caches frequently accessed array elements in local variables within loops. When accessing the same array element multiple times, storing it in a local variable reduces the number of expensive array indexing operations, as each array access requires computing the storage slot location.

## Example

### Original (Repeated Array Access)
```solidity
contract RepeatedArrayAccess {
    struct User {
        string name;
        uint balance;
        bool active;
    }
    
    User[] public users;
    
    function processUsers() public {
        for (uint i = 0; i < users.length; i++) {
            // Multiple accesses to users[i] - repeated offset calculations
            if (users[i].active && users[i].balance > 100) {
                users[i].balance = users[i].balance - 10;
                
                if (users[i].balance < 50) {
                    users[i].active = false;
                }
            }
        }
    }
}
```

### Optimised (Cached Array Members)
```solidity
contract CachedArrayMembers {
    struct User {
        string name;
        uint balance;
        bool active;
    }
    
    User[] public users;
    
    function processUsers() public {
        for (uint i = 0; i < users.length; i++) {
            // Cache array element reference once
            User storage user = users[i];
            
            if (user.active && user.balance > 100) {
                user.balance = user.balance - 10;
                
                if (user.balance < 50) {
                    user.active = false;
                }
            }
        }
    }
}
```

## Gas Savings

Caching array elements reduces gas consumption by computing the storage slot offset once instead of on every access to the same array element.