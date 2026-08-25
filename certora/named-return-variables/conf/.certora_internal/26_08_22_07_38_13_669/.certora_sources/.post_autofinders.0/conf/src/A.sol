// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    mapping(uint256 => uint256) public values;
    mapping(uint256 => address) public owners;
    uint256 public total;

    uint256 public lastScale;
    address public lastPackWho;
    uint256 public lastPackAmount;
    bool public lastPackActive;
    uint256 public lastAccumulate;
    uint256 public lastClassify;
    uint256 public lastGuard;

    function scale(uint256 id, uint256 factor) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006001, factor) }
        uint256 result = values[id] * factor;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,result)}
        return result + 1;
    }

    function pack(uint256 id) internal view returns (address, uint256, bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016000, id) }
        address who = owners[id];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,who)}
        uint256 amount = values[id];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,amount)}
        bool active = amount != 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,active)}
        return (who, amount, active);
    }

    function accumulate(uint256 id, uint256 amount) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036001, amount) }
        uint256 updated = values[id] + amount;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,updated)}
        values[id] = updated;
        total = total + amount;
        return updated;
    }

    function classify(uint256 id) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046000, id) }
        uint256 amount = values[id];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,amount)}
        if (amount == 0) {
            return 0;
        }
        uint256 tier = amount / 100;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,tier)}
        return tier;
    }

    function guard(uint256 id) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026000, id) }
        uint256 flagged;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,flagged)}
        if (values[id] > 100) {
            flagged = values[id];
        }
        return flagged;
    }

    function scale_instr(uint256 id, uint256 factor) external {
        lastScale = scale(id, factor);
    }

    function pack_instr(uint256 id) external {
        (address who, uint256 amount, bool active) = pack(id);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010009,0)}
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

    function guard_instr(uint256 id) external {
        lastGuard = guard(id);
    }
}
