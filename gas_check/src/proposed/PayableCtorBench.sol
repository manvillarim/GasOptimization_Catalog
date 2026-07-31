// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 30 (Make Constructors Payable).
//
// WHY THREE CONSTRUCTOR COMPLEXITIES. The rule removes a single `CALLVALUE`
// check emitted at the head of the creation code, so the absolute saving is a
// constant of a few dozen gas and the *relative* saving must shrink as the
// constructor does more work. The original single-instance measurement
// reported "<1%" without evidence that the figure was stable; instantiating a
// minimal, a moderate and a heavy constructor tests exactly that, and lets the
// paper state whether the marginal benefit is constant in absolute terms
// (expected) or in relative terms (not expected).
//
// WHY THE HEAVY VARIANT WRITES A LOOP OF SLOTS. Storage writes dominate any
// realistic constructor, so a loop of SSTOREs is the cheapest faithful way to
// grow constructor cost by orders of magnitude without changing anything else
// about the contract's shape or its runtime surface.
//
// WHY THE RUNTIME SURFACE IS IDENTICAL ACROSS ALL SIX CONTRACTS. The rule
// touches creation code only. Keeping the same three getters everywhere makes
// the average-function column a control: it must show a 0.00% difference, and
// any deviation would indicate a measurement fault rather than a real effect.

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
