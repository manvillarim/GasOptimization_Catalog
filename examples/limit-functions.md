# 19. Limit Number of Functions

This transformation merges several entry points into one that takes the operation as an argument. Each external function contributes an entry to the selector dispatch table and its own copy of the argument decoding, so removing entry points reduces the deployed code.

## Example

### Original (One Function per Operation)
```solidity
contract A {
    uint256 private value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 newValue) public {
        value = newValue;
    }

    function incrementValue() public {
        value++;
    }

    function multiplyValue(uint256 multiplier) public {
        value *= multiplier;
    }

    function divideValue(uint256 divisor) public {
        require(divisor != 0, "Division by zero");
        value /= divisor;
    }
}
```

### Optimised (Consolidated Entry Point)
```solidity
contract Ao {
    uint256 private value;

    enum Operation { SET, INCREMENT, MULTIPLY, DIVIDE }

    function getValue() public view returns (uint256) {
        return value;
    }

    function modifyValue(Operation op, uint256 operand) public {
        if (op == Operation.SET) {
            value = operand;
        } else if (op == Operation.INCREMENT) {
            value++;
        } else if (op == Operation.MULTIPLY) {
            value *= operand;
        } else if (op == Operation.DIVIDE) {
            require(operand != 0, "Division by zero");
            value /= operand;
        }
    }
}
```

## Applicability

This rule changes the interface, and it is the only one of the catalogue that does. The four selectors of `A` are gone, so a client written against it does not work against `Ao`, and the two contracts are not equivalent in the sense used everywhere else here, where a call is compared against the same call.

What is verified instead is equivalence under a translation of calls: `setValue(x)` against `modifyValue(SET, x)`, `incrementValue()` against `modifyValue(INCREMENT, 0)`, and so on. Each pair is discharged by its own rule, and the coupling invariant remains the equality of the state. Applying the transformation therefore requires updating every caller, which the rule does not do and which the proof does not cover.

The dispatch is also no longer free at runtime: the chain of comparisons on `op` replaces a jump through the selector table, and it costs more for the operations that appear late in the chain.

## Gas Savings

The saving is in deployment, and it is the dispatch entries and the argument decoding of the removed functions. Runtime cost may rise, so the rule is worth applying under a code-size constraint rather than to reduce the cost of a call.
