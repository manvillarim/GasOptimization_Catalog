// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    uint256 private value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 _value) public {
        value = _value;
    }

    function incrementValue() public {
        value++;
    }

    function decrementValue() public {
        if (value > 0) {
            value--;
        }
    }

    function multiplyValue(uint256 multiplier) public {
        value *= multiplier;
    }

    function divideValue(uint256 divisor) public {
        require(divisor != 0, "Division by zero");
        value /= divisor;
    }
}