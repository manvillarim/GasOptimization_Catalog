# 19. Limit Number of Functions

This transformation consolidates multiple related functions into fewer, more comprehensive functions. Reducing the total number of functions decreases contract deployment size and cost by minimizing the function selector dispatch overhead in the contract bytecode, though care must be taken to maintain code clarity and security.

## Example

### Original (Multiple Small Functions)
```solidity
contract MultipleFunctions {
    uint private value;
    
    function setValue(uint _value) public {
        value = _value;
    }
    
    function incrementValue() public {
        value++;
    }
    
    function decrementValue() public {
        value--;
    }
    
    function multiplyValue(uint multiplier) public {
        value *= multiplier;
    }
    
    function divideValue(uint divisor) public {
        require(divisor != 0, "Division by zero");
        value /= divisor;
    }
    
    function getValue() public view returns (uint) {
        return value;
    }
}
```

### Optimised (Consolidated Functions)
```solidity
contract ConsolidatedFunctions {
    uint private value;
    
    enum Operation { SET, INCREMENT, DECREMENT, MULTIPLY, DIVIDE }
    
    function modifyValue(Operation op, uint operand) public {
        if (op == Operation.SET) {
            value = operand;
        } else if (op == Operation.INCREMENT) {
            value++;
        } else if (op == Operation.DECREMENT) {
            value--;
        } else if (op == Operation.MULTIPLY) {
            value *= operand;
        } else if (op == Operation.DIVIDE) {
            require(operand != 0, "Division by zero");
            value /= operand;
        }
    }
    
    function getValue() public view returns (uint) {
        return value;
    }
}
```

## Gas Savings

Consolidating functions reduces contract deployment size and cost by minimizing function selector dispatch overhead, though this must be balanced against code readability and maintainability requirements.