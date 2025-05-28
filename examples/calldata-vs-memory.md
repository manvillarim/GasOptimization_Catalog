# 11. Use calldata instead of memory for function parameters

This transformation changes function parameter data location from memory to calldata for external functions. Calldata is a read-only, non-persistent area where function arguments are stored, and it's cheaper to access than memory, resulting in significant gas savings.

## Example

### Memory Parameters
```solidity
contract MemoryParams {
    function processArray(uint[] memory data) external pure returns(uint sum) {
        for(uint i = 0; i < data.length; i++) {
            sum += data[i];
        }
    }
    
    function processStruct(User memory user) external pure returns(string memory) {
        return user.name;
    }
}

struct User {
    string name;
    uint age;
}

```

### Optimized Calldata Parameters

```solidity
contract CalldataParams {
    function processArray(uint[] calldata data) external pure returns(uint sum) {
        for(uint i = 0; i < data.length; i++) {
            sum += data[i];
        }
    }
    
    function processStruct(User calldata user) external pure returns(string memory) {
        return user.name;
    }
}

struct User {
    string name;
    uint age;
}

```