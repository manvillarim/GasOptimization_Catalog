# 10. Avoid explicit zero initialization

This transformation removes unnecessary explicit initialization of variables with zero values. In Solidity, variables are automatically initialized with their default zero values, making explicit initialization redundant and wasteful in terms of gas consumption.

## Example

### Explicit Zero Initialization
```solidity
contract ExplicitInit {
    uint public counter = 0;
    bool public flag = false;
    address public owner = address(0);
    
    function resetValues() public {
        uint temp = 0;
        bool status = false;
        // Process with temp and status
    }
}
```
### Optimized Default Initialization

```solidity
contract OptimizedInit {
    uint public counter; // Automatically initialized to 0
    bool public flag; // Automatically initialized to false
    address public owner; // Automatically initialized to address(0)
    
    function resetValues() public {
        uint temp; // Automatically initialized to 0
        bool status; // Automatically initialized to false
        // Process with temp and status
    }
}
```
