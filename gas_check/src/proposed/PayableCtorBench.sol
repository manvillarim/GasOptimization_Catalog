// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 30 (Make Constructors Payable), instantiated at three
// constructor workloads: minimal, simple and a loop of SSTOREs. The rule
// touches creation code only, so all six contracts keep the same runtime
// surface and the average-function column acts as a control.

contract PC_A_Min {
    uint256 public value;

    constructor() {
        value = 1;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function setValue(uint256 v) external {
        value = v;
    }

    function bump() external {
        value = value + 1;
    }
}

contract PC_Ao_Min {
    uint256 public value;

    constructor() payable {
        value = 1;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function setValue(uint256 v) external {
        value = v;
    }

    function bump() external {
        value = value + 1;
    }
}

contract PC_A_Simple {
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

    function setValue(uint256 v) external {
        value = v;
    }

    function bump() external {
        counter = counter + 1;
    }
}

contract PC_Ao_Simple {
    address public owner;
    uint256 public value;
    string public name;
    uint256 public counter;

    constructor(address _owner, uint256 _value, string memory _name) payable {
        owner = _owner;
        value = _value;
        name = _name;
        counter = 0;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function setValue(uint256 v) external {
        value = v;
    }

    function bump() external {
        counter = counter + 1;
    }
}

contract PC_A_Heavy {
    address public owner;
    uint256 public value;
    string public name;
    uint256 public counter;
    mapping(uint256 => uint256) public table;

    constructor(address _owner, uint256 _value, string memory _name, uint256 slots) {
        owner = _owner;
        value = _value;
        name = _name;
        counter = 0;
        for (uint256 i = 0; i < slots; i++) {
            table[i] = i + 1;
        }
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function setValue(uint256 v) external {
        value = v;
    }

    function bump() external {
        counter = counter + 1;
    }
}

contract PC_Ao_Heavy {
    address public owner;
    uint256 public value;
    string public name;
    uint256 public counter;
    mapping(uint256 => uint256) public table;

    constructor(
        address _owner,
        uint256 _value,
        string memory _name,
        uint256 slots
    ) payable {
        owner = _owner;
        value = _value;
        name = _name;
        counter = 0;
        for (uint256 i = 0; i < slots; i++) {
            table[i] = i + 1;
        }
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function setValue(uint256 v) external {
        value = v;
    }

    function bump() external {
        counter = counter + 1;
    }
}
