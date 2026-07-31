// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    mapping(uint256 => uint256) public values;
    mapping(uint256 => address) public owners;
    uint256 public total;

    uint256 public lastScale;
    address public lastPackWho;
    uint256 public lastPackAmount;
    bool public lastPackActive;
    uint256 public lastAccumulate;
    uint256 public lastClassify;

    function scale(uint256 id, uint256 factor) internal view returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046001, factor) }
        result = values[id] * factor;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,result)}
        result += 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,result)}
    }

    function pack(uint256 id) internal view returns (address who, uint256 amount, bool active) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, id) }
        who = owners[id];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,who)}
        amount = values[id];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,amount)}
        active = amount != 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,active)}
    }

    function accumulate(uint256 id, uint256 amount) internal returns (uint256 updated) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00066001, amount) }
        updated = values[id] + amount;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,updated)}
        values[id] = updated;
        total = total + amount;
    }

    function classify(uint256 id) internal view returns (uint256 tier) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076000, id) }
        uint256 amount = values[id];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,amount)}
        if (amount == 0) {
            return 0;
        }
        tier = amount / 100;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,tier)}
    }

    function scale_instr(uint256 id, uint256 factor) external {
        lastScale = scale(id, factor);
    }

    function pack_instr(uint256 id) external {
        (address who, uint256 amount, bool active) = pack(id);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010002,0)}
        lastPackWho = who;
        lastPackAmount = amount;
        lastPackActive = active;
    }

    function accumulate_instr(uint256 id, uint256 amount) external {
        lastAccumulate = accumulate(id, amount);
    }

    function classify_instr(uint256 id) external {
        lastClassify = classify(id);
    }
}
