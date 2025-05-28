# 9. Use fixed-size arrays instead of dynamic arrays

This transformation replaces dynamic arrays with fixed-size arrays when the maximum size is known beforehand. Fixed-size arrays have predetermined memory allocation, which is more gas-efficient than dynamic allocation during contract execution. This optimization reduces gas consumption by avoiding the overhead of dynamic memory management.

## Example

### Dynamic Array
```solidity
contract DynamicArrayContract {
   uint[] public numbers;
   
   function addNumbers(uint count) public {
       for(uint i = 0; i < count; i++) {
           numbers.push(i);
       }
   }
   
   function getNumber(uint index) public view returns(uint) {
       return numbers[index];
   }
}
```

### Optimized Fixed-Size Array

```solidity
contract FixedArrayContract {
    uint[100] public numbers; // Fixed size array
    uint public currentLength;
    
    function addNumbers(uint count) public {
        require(currentLength + count <= 100, "Array overflow");
        for(uint i = 0; i < count; i++) {
            numbers[currentLength + i] = i;
        }
        currentLength += count;
    }
    
    function getNumber(uint index) public view returns(uint) {
        require(index < currentLength, "Index out of bounds");
        return numbers[index];
    }
}
```