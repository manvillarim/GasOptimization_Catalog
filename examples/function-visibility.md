# 12. Use Appropriate Function Visibility

This transformation optimizes function visibility modifiers to reduce gas consumption. Using `external` instead of `public` for functions only called externally saves gas by avoiding unnecessary copying of calldata to memory. Using `internal` or `private` for functions only called within the contract eliminates the overhead of external function call encoding.

## Example

### Original (Suboptimal Visibility)
```solidity
contract SuboptimalVisibility {
    uint private value;
    
    // Public function called only externally
    function setValue(uint _value) public {
        value = _value;
    }
    
    // Public function used only internally
    function getValue() public view returns (uint) {
        return value;
    }
    
    function processValue() public {
        uint current = getValue();  // Unnecessary overhead
        setValue(current * 2);      // Unnecessary overhead
    }
}
```

### Optimised (Appropriate Visibility)
```solidity
contract OptimizedVisibility {
    uint private value;
    
    // External for functions called only from outside
    function setValue(uint _value) external {
        value = _value;
    }
    
    // Internal for functions used only within contract
    function getValue() internal view returns (uint) {
        return value;
    }
    
    function processValue() external {
        uint current = getValue();  // Efficient internal call
        value = current * 2;
    }
}
```

## Gas Savings

Using `external` instead of `public` avoids copying calldata parameters to memory. Using `internal` or `private` for helper functions eliminates the overhead of external function call encoding and decoding.