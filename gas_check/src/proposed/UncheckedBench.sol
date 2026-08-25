// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 28 (Use `unchecked` arithmetic for validated operations),
// instantiated at N = 100, 1000 and 5000 with two loop bodies: `Arith` performs
// pure arithmetic, `Sload` reads a storage slot per iteration. N is a
// compile-time constant, so every instance is a contract pair of its own.
//
// In `Arith` the guard `start >= N` is hoisted out of the loop, which makes
// every decrement non-negative by construction. In `Sload` each seeded slot
// holds 1, so the accumulator is bounded by N and cannot overflow.

contract UA_A_Arith100 {
    uint256 public sink;

    function run(uint256 start) external returns (uint256) {
        require(start >= 100, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < 100; i++) {
            counter -= 1;
        }
        sink = counter;
        return counter;
    }
}

contract UA_Ao_Arith100 {
    uint256 public sink;

    function run(uint256 start) external returns (uint256) {
        require(start >= 100, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < 100; i++) {
            unchecked {
                counter -= 1;
            }
        }
        sink = counter;
        return counter;
    }
}

contract UA_A_Arith1000 {
    uint256 public sink;

    function run(uint256 start) external returns (uint256) {
        require(start >= 1000, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < 1000; i++) {
            counter -= 1;
        }
        sink = counter;
        return counter;
    }
}

contract UA_Ao_Arith1000 {
    uint256 public sink;

    function run(uint256 start) external returns (uint256) {
        require(start >= 1000, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < 1000; i++) {
            unchecked {
                counter -= 1;
            }
        }
        sink = counter;
        return counter;
    }
}

contract UA_A_Arith5000 {
    uint256 public sink;

    function run(uint256 start) external returns (uint256) {
        require(start >= 5000, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < 5000; i++) {
            counter -= 1;
        }
        sink = counter;
        return counter;
    }
}

contract UA_Ao_Arith5000 {
    uint256 public sink;

    function run(uint256 start) external returns (uint256) {
        require(start >= 5000, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < 5000; i++) {
            unchecked {
                counter -= 1;
            }
        }
        sink = counter;
        return counter;
    }
}

contract UA_A_Sload100 {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed() external {
        for (uint256 i = 0; i < 100; i++) {
            slots[i] = 1;
        }
    }

    function run() external returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < 100; i++) {
            total += slots[i];
        }
        sink = total;
        return total;
    }
}

contract UA_Ao_Sload100 {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed() external {
        for (uint256 i = 0; i < 100; i++) {
            slots[i] = 1;
        }
    }

    function run() external returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < 100; i++) {
            unchecked {
                total += slots[i];
            }
        }
        sink = total;
        return total;
    }
}

contract UA_A_Sload1000 {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed() external {
        for (uint256 i = 0; i < 1000; i++) {
            slots[i] = 1;
        }
    }

    function run() external returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < 1000; i++) {
            total += slots[i];
        }
        sink = total;
        return total;
    }
}

contract UA_Ao_Sload1000 {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed() external {
        for (uint256 i = 0; i < 1000; i++) {
            slots[i] = 1;
        }
    }

    function run() external returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < 1000; i++) {
            unchecked {
                total += slots[i];
            }
        }
        sink = total;
        return total;
    }
}

contract UA_A_Sload5000 {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed() external {
        for (uint256 i = 0; i < 5000; i++) {
            slots[i] = 1;
        }
    }

    function run() external returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < 5000; i++) {
            total += slots[i];
        }
        sink = total;
        return total;
    }
}

contract UA_Ao_Sload5000 {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed() external {
        for (uint256 i = 0; i < 5000; i++) {
            slots[i] = 1;
        }
    }

    function run() external returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < 5000; i++) {
            unchecked {
                total += slots[i];
            }
        }
        sink = total;
        return total;
    }
}
