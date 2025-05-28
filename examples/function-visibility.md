# 13. Use appropriate function visibility

This transformation optimizes function visibility modifiers to reduce gas consumption. Using the most restrictive appropriate visibility (external vs public, internal vs private) can save gas by avoiding unnecessary overhead in function calls and reducing the contract's bytecode size.

## Example

### Suboptimal Function Visibility
```solidity
contract SuboptimalVisibility {
    uint private value;
    
    // Public function called only externally
    function setValue(uint _value) public {
        value = _value;
    }
    
    // Public function used internally
    function getValue() public view returns(uint) {
        return value;
    }
    
    function processValue() public {
        uint current = getValue(); // Internal call to public function
        setValue(current * 2);     // Internal call to public function
    }
}
```
### Optimized Function Visibility

```solidity
contract OptimizedVisibility {
    uint private value;
    
    // External function for external calls only
    function setValue(uint _value) external {
        value = _value;
    }
    
    // Internal function for internal use
    function getValue() internal view returns(uint) {
        return value;
    }
    
    // Public function that uses internal function
    function processValue() external {
        uint current = getValue(); // Internal call
        value = current * 2;       // Direct assignment
    }
}
```
