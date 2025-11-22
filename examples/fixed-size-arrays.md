# 8. Use Fixed-Size Arrays Instead of Dynamic Arrays

This transformation replaces dynamic arrays with fixed-size arrays when the maximum size is known at compile time. Fixed-size arrays avoid the overhead of dynamic memory management and length tracking, resulting in more efficient storage layout and cheaper array access operations.

## Example

### Original (Dynamic Array)
```solidity
contract DynamicArrayContract {
    uint[] public numbers;
    
    function addNumbers(uint count) public {
        for (uint i = 0; i < count; i++) {
            numbers.push(i);
        }
    }
    
    function getNumber(uint index) public view returns (uint) {
        return numbers[index];
    }
}
```

### Optimised (Fixed-Size Array)
```solidity
contract FixedArrayContract {
    uint[100] public numbers;  // Fixed size known at compile time
    uint public currentLength;
    
    function addNumbers(uint count) public {
        require(currentLength + count <= 100, "Array overflow");
        for (uint i = 0; i < count; i++) {
            numbers[currentLength + i] = i;
        }
        currentLength += count;
    }
    
    function getNumber(uint index) public view returns (uint) {
        require(index < currentLength, "Index out of bounds");
        return numbers[index];
    }
}
```

## Gas Savings

Fixed-size arrays eliminate the storage overhead of tracking array length dynamically and avoid costly push operations, reducing gas consumption for both writes and reads when the maximum size is known beforehand.