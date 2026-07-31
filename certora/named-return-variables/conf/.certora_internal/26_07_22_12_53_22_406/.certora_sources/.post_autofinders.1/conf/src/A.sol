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

    function scale(uint256 id, uint256 factor) internal view returns (uint256) {
        uint256 result = values[id] * factor;
        return result + 1;
    }

    function pack(uint256 id) internal view returns (address, uint256, bool) {
        address who = owners[id];
        uint256 amount = values[id];
        bool active = amount != 0;
        return (who, amount, active);
    }

    function accumulate(uint256 id, uint256 amount) internal returns (uint256) {
        uint256 updated = values[id] + amount;
        values[id] = updated;
        total = total + amount;
        return updated;
    }

    function classify(uint256 id) internal view returns (uint256) {
        uint256 amount = values[id];
        if (amount == 0) {
            return 0;
        }
        uint256 tier = amount / 100;
        return tier;
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
}
