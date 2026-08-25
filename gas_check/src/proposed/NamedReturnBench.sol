// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 31 (Named Return Variables), instantiated at three return
// widths: one word, three words and a memory struct of eight fields. Each pair
// differs only in whether the returned values are declared in the signature.

struct Wide {
    uint256 a;
    uint256 b;
    uint256 c;
    uint256 d;
    address e;
    address f;
    bool g;
    bool h;
}

contract NR_A_One {
    mapping(uint256 => uint256) public values;

    function get(uint256 id, uint256 factor) external view returns (uint256) {
        uint256 result = values[id] * factor;
        return result + 1;
    }
}

contract NR_Ao_One {
    mapping(uint256 => uint256) public values;

    function get(uint256 id, uint256 factor) external view returns (uint256 result) {
        result = values[id] * factor;
        result += 1;
    }
}

contract NR_A_Three {
    mapping(uint256 => uint256) public values;
    mapping(uint256 => address) public owners;

    function get(uint256 id) external view returns (address, uint256, bool) {
        address who = owners[id];
        uint256 amount = values[id];
        bool active = amount != 0;
        return (who, amount, active);
    }
}

contract NR_Ao_Three {
    mapping(uint256 => uint256) public values;
    mapping(uint256 => address) public owners;

    function get(uint256 id) external view returns (address who, uint256 amount, bool active) {
        who = owners[id];
        amount = values[id];
        active = amount != 0;
    }
}

contract NR_A_Struct {
    mapping(uint256 => uint256) public values;
    mapping(uint256 => address) public owners;

    function get(uint256 id) external view returns (Wide memory) {
        Wide memory w;
        w.a = values[id];
        w.b = values[id] + 1;
        w.c = values[id] + 2;
        w.d = values[id] + 3;
        w.e = owners[id];
        w.f = owners[id + 1];
        w.g = w.a != 0;
        w.h = w.b != 0;
        return w;
    }
}

contract NR_Ao_Struct {
    mapping(uint256 => uint256) public values;
    mapping(uint256 => address) public owners;

    function get(uint256 id) external view returns (Wide memory w) {
        w.a = values[id];
        w.b = values[id] + 1;
        w.c = values[id] + 2;
        w.d = values[id] + 3;
        w.e = owners[id];
        w.f = owners[id + 1];
        w.g = w.a != 0;
        w.h = w.b != 0;
    }
}
