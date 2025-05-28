# 2. Replace dynamic arrays with mappings

In Solidity, both `arrays` and `mappings` are commonly used for storing collections of data. However, when gas efficiency is a priority — particularly for storage and lookup operations — `mappings` can often be significantly cheaper than `arrays`.

## Key Differences in Storage and Access

### Arrays
- Arrays store elements **sequentially** in storage.
- Reading an element requires calculating its index.
- **Searching** for an element (e.g., checking if a value exists) often requires iterating over the array — an **O(n)** operation.
- Appending or removing elements involves **shifting** storage slots or maintaining indexes, which can be gas-intensive.

### Mappings
- Mappings act like **hash tables**, enabling **constant-time O(1)** access.
- No iteration is needed to check if a key exists.
- The storage layout avoids unnecessary data movement or reordering.
- Ideal for flags (e.g., membership) or value associations (e.g., balances, roles).

## Example Comparison

### Using an Array (More Expensive)
```solidity
address[] public whitelist;

function isWhitelisted(address user) public view returns (bool) {
    for (uint i = 0; i < whitelist.length; i++) {
        if (whitelist[i] == user) {
            return true;
        }
    }
    return false;
}
```
### Using Mapping(cheaper)
```solidity
mapping(address => bool) public isWhitelisted;

function addToWhitelist(address user) public {
    isWhitelisted[user] = true;
}
