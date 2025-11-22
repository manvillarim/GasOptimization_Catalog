# 25. Cache Array Length in Loops

This transformation caches the array length in a local variable before loop execution. Reading the `length` property of storage arrays costs gas (SLOAD operation), and when accessed repeatedly in loop conditions, it significantly increases gas consumption. Caching the length in memory reduces this to a single SLOAD plus cheaper MLOAD operations.

## Example

### Original (Uncached Array Length)
```solidity
contract UncachedLength {
    uint[] public numbers;
    
    function processArray() public {
        // Array length read from storage on every iteration
        for (uint i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function sumArray() public view returns (uint sum) {
        // Length accessed repeatedly in condition check
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
    }
}
```

### Optimised (Cached Array Length)
```solidity
contract CachedLength {
    uint[] public numbers;
    
    function processArray() public {
        uint length = numbers.length; // Cache length once
        for (uint i = 0; i < length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function sumArray() public view returns (uint sum) {
        uint length = numbers.length; // Single SLOAD
        for (uint i = 0; i < length; i++) {
            sum += numbers[i];
        }
    }
}
```

## Gas Savings

Caching array length reduces gas consumption by replacing repeated storage read operations with cheaper memory read operations.# 25. Cache Array Length in Loops

This transformation caches the array length in a local variable before loop execution. Reading the `length` property of storage arrays costs gas (SLOAD operation), and when accessed repeatedly in loop conditions, it significantly increases gas consumption. Caching the length in memory reduces this to a single SLOAD plus cheaper MLOAD operations.

## Example

### Original (Uncached Array Length)
```solidity
contract UncachedLength {
    uint[] public numbers;
    
    function processArray() public {
        // Array length read from storage on every iteration
        for (uint i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function sumArray() public view returns (uint sum) {
        // Length accessed repeatedly in condition check
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
    }
}
```

### Optimised (Cached Array Length)
```solidity
contract CachedLength {
    uint[] public numbers;
    
    function processArray() public {
        uint length = numbers.length; // Cache length once
        for (uint i = 0; i < length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function sumArray() public view returns (uint sum) {
        uint length = numbers.length; // Single SLOAD
        for (uint i = 0; i < length; i++) {
            sum += numbers[i];
        }
    }
}
```

## Gas Savings

Caching array length reduces gas consumption by replacing repeated storage read operations with cheaper memory read operations.