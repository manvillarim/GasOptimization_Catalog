# 10. Use Calldata Instead of Memory for Function Parameters

This transformation changes function parameter data location from `memory` to `calldata` for external functions. Calldata is a read-only area where function arguments are stored, and accessing it is cheaper than copying data to memory. This optimization only applies to `external` functions, as `calldata` is not available for `public` or `internal` functions.

## Example

### Original (Memory Parameters)
```solidity
contract MemoryParams {
    struct User {
        string name;
        uint age;
    }
    
    function processArray(uint[] memory data) external pure returns (uint sum) {
        // Data copied from calldata to memory
        for (uint i = 0; i < data.length; i++) {
            sum += data[i];
        }
    }
    
    function processStruct(User memory user) external pure returns (string memory) {
        // Struct copied from calldata to memory
        return user.name;
    }
}
```

### Optimised (Calldata Parameters)
```solidity
contract CalldataParams {
    struct User {
        string name;
        uint age;
    }
    
    function processArray(uint[] calldata data) external pure returns (uint sum) {
        // Data read directly from calldata (no copy)
        for (uint i = 0; i < data.length; i++) {
            sum += data[i];
        }
    }
    
    function processStruct(User calldata user) external pure returns (string memory) {
        // Struct read directly from calldata (no copy)
        return user.name;
    }
}
```

## Gas Savings

Using `calldata` instead of `memory` eliminates the cost of copying function arguments from calldata to memory, reducing gas consumption for external function calls with array or struct parameters.