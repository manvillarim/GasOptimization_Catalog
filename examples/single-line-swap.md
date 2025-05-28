# 19. Use single-line variable swapping

This transformation replaces traditional three-step variable swapping with Solidity's built-in tuple assignment. This eliminates the need for a temporary variable and reduces the number of operations, resulting in lower gas consumption.

## Example

### Traditional Variable Swap
```solidity
contract TraditionalSwap {
    uint public valueA;
    uint public valueB;
    
    function swapValues() public {
        // Traditional swap using temporary variable
        uint temp = valueA;
        valueA = valueB;
        valueB = temp;
    }
    
    function swapArrayElements(uint[] memory arr, uint i, uint j) public pure {
        // Traditional array element swap
        uint temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}
```

### Traditional Variable Swap

```solidity
contract OptimizedSwap {
    uint public valueA;
    uint public valueB;
    
    function swapValues() public {
        // Single-line swap using tuple assignment
        (valueA, valueB) = (valueB, valueA);
    }
    
    function swapArrayElements(uint[] memory arr, uint i, uint j) public pure {
        // Single-line array element swap
        (arr[i], arr[j]) = (arr[j], arr[i]);
    }
}
```