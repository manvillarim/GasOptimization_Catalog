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
    uint256 public lastGuard;

    function scale(uint256 id, uint256 factor) internal view returns (uint256 result) {
        result = values[id] * factor;
        result += 1;
    }

    function pack(uint256 id) internal view returns (address who, uint256 amount, bool active) {
        who = owners[id];
        amount = values[id];
        active = amount != 0;
    }

    function accumulate(uint256 id, uint256 amount) internal returns (uint256 updated) {
        updated = values[id] + amount;
        values[id] = updated;
        total = total + amount;
    }

    function classify(uint256 id) internal view returns (uint256 tier) {
        uint256 amount = values[id];
        if (amount == 0) {
            return 0;
        }
        tier = amount / 100;
    }

    function guard(uint256 id) internal view returns (uint256 flagged) {
        if (values[id] > 100) {
            flagged = values[id];
        }
    }

    function scale_instr(uint256 id, uint256 factor) external {
        lastScale = scale(id, factor);
    }

    function pack_instr(uint256 id) external {
        (address who, uint256 amount, bool active) = pack(id);
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
