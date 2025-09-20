// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    uint256 private value;

    enum Operation { SET, INCREMENT, DECREMENT, MULTIPLY, DIVIDE }

    function getValue() public view returns (uint256) {
        return value;
    }

    function modifyValue(Operation op, uint256 operand) public {
        if (op == Operation.SET) {
            value = operand;
        } else if (op == Operation.INCREMENT) {
            value++;
        } else if (op == Operation.DECREMENT) {
            if (value > 0) {
                value--;
            }
        } else if (op == Operation.MULTIPLY) {
            value *= operand;
        } else if (op == Operation.DIVIDE) {
            require(operand != 0, "Division by zero");
            value /= operand;
        }
    }
}