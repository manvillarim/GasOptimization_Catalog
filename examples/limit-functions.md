# 20. Limit number of functions

This transformation consolidates multiple small functions into fewer, more comprehensive functions. While maintaining readability and security, reducing the total number of functions decreases contract deployment costs and can improve execution efficiency by reducing function call overhead.

## Example

### Multiple Small Functions
```solidity
contract MultipleFunctions {
    uint private value;
    
    function setValue(uint _value) public {
        value = _value;
    }
    
    function getValue() public view returns(uint) {
        return value;
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
}
```

### Optimized Consolidated Functions

```solidity
contract ConsolidatedFunctions {
    uint private value;
    
    enum Operation { SET, INCREMENT, DECREMENT, MULTIPLY, DIVIDE }
    
    function modifyValue(Operation op, uint operand) public {
        if(op == Operation.SET) {
            value = operand;
        } else if(op == Operation.INCREMENT) {
            value++;
        } else if(op == Operation.DECREMENT) {
            value--;
        } else if(op == Operation.MULTIPLY) {
            value *= operand;
        } else if(op == Operation.DIVIDE) {
            require(operand != 0, "Division by zero");
            value /= operand;
        }
    }
    
    function getValue() public view returns(uint) {
        return value;
    }
}
```