// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    uint256 private value;

    enum Operation { SET, INCREMENT, DECREMENT, MULTIPLY, DIVIDE }

    function getValue() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060004, 0) }
        return value;
    }

    function modifyValue(Operation op, uint256 operand) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076001, operand) }
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