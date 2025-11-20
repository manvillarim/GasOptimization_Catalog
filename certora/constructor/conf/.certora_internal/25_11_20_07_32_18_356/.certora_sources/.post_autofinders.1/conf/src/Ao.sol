// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    address public owner;
    uint256 public value;
    string public name;
    uint256 public counter;

    constructor(address _owner, uint256 _value, string memory _name) {
        owner = _owner;
        value = _value;
        name = _name;
        counter = 0;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

        function incrementCounter() external {
        counter++;
    }

    function setValue(uint256 _newValue) external {
        value = _newValue;
    }

    function setOwner(address _newOwner) external {
        owner = _newOwner;
    }
}