# 27. Use Mappings Instead of Arrays for Data Lists

This transformation replaces dynamic arrays with mappings combined with a manual size counter. Mappings provide more efficient storage and retrieval operations compared to arrays, particularly for large datasets. For Solidity 0.8.0+, the `unchecked` block around the size increment is necessary to maintain behavioural equivalence with array `push()` operations regarding overflow behaviour.

## Example

### Original (Dynamic Array)
```solidity
contract ArrayContract {
    uint256[] public numbers;
    
    function addNumber(uint256 number) public {
        numbers.push(number);
    }
    
    function getNumber(uint256 index) public view returns (uint256) {
        require(index < size, "Index out of bounds");
        return numbers[index];
    }
}
```

### Optimised (Mapping with Manual Size Tracking)
```solidity
contract MappingContract {
    mapping(uint256 => uint256) public numbers;
    uint256 public size;
    
    function addNumber(uint256 number) public {
        numbers[size] = number;
        unchecked { size++; }  // Preserves overflow behaviour of push()
    }
    
    function getNumber(uint256 index) public view returns (uint256) {
        require(index < size, "Index out of bounds");
        return numbers[index];
    }
}
```

## Gas Savings

Mappings eliminate the overhead of dynamic array operations while providing efficient key-based access. The `unchecked` block around `size++` is required in Solidity 0.8.0+ to maintain behavioural equivalence with array `push()`, which does not revert on overflow.