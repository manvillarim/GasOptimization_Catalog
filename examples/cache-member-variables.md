# 24. Cache Array Member Variables

This transformation binds an array element to a local storage pointer before the accesses that use it. Every occurrence of `users[i]` recomputes the location of the element and repeats the bounds check on `i`; the pointer performs that work once and each subsequent access is a direct read or write of the field.

## Example

### Original (Repeated Array Access)
```solidity
contract A {
    struct User {
        uint256 balance;
        bool active;
    }

    User[] public users;

    function processUsers() public {
        for (uint256 i = 0; i < users.length; i++) {
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

### Optimised (Cached Element Pointer)
```solidity
contract Ao {
    struct User {
        uint256 balance;
        bool active;
    }

    User[] public users;

    function processUsers() public {
        for (uint256 i = 0; i < users.length; i++) {
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

## Applicability

`User storage user` is an alias and not a copy, so the reads still reach storage and every write through it is immediately visible. This is what makes the transformation behaviour-preserving without further conditions: the two versions read and write the same slots in the same order.

Caching the *value* of a member instead, in a `uint256` local, is a different transformation. It does remove the repeated SLOAD, but it is only sound when nothing between the read and the write-back can observe or modify that slot, which excludes bodies performing external calls.

## Gas Savings

The saving is the address arithmetic and the bounds check that each additional occurrence of `users[i]` would perform, multiplied by the number of accesses per iteration. It grows with the number of times the same element is named inside the loop body.
