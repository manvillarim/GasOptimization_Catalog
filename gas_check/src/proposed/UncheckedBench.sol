// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 28 (Use `unchecked` arithmetic for validated operations).
//
// WHY ONE CONTRACT PAIR PER INSTANCE. The saving of this rule is one elided
// overflow check per executed arithmetic operation, so it is expected to be
// linear in the number of iterations. An earlier version of this benchmark
// took the trip count as an argument of the call, which meant a single pair of
// contracts served all three sizes and no deployment figure could be attributed
// to an individual instance. Fixing the trip count as a compile-time constant
// gives every instance its own pair, measured on the same footing as the other
// three rules of the paper: one deployment cost, one deployment size and one
// execution cost each.
//
// WHY TWO LOOP BODIES. `Arith` performs pure arithmetic; `Sload` reads a
// storage slot per iteration. The pair separates sensitivity to the size of the
// problem from sensitivity to what else the loop does: the elided check is a
// fixed number of gas units per iteration, so it is a large share of an
// arithmetic body and a small share of one that pays for an SLOAD.
//
// WHY THE GUARD IS HOISTED OUT OF THE LOOP. `unchecked` is sound in `Arith`
// only because `start >= N` is established before the loop, which makes every
// decrement non-negative by construction. Keeping that validation outside the
// measured body is also what makes the two versions of a pair differ in exactly
// one respect: the presence of the redundant per-iteration check.
//
// WHY EACH SEEDED SLOT HOLDS 1. In `Sload` the accumulator is bounded by N,
// itself at most 5000, so the elided overflow check is unreachable by
// construction and the two versions are equivalent on every state rather than
// only on the states exercised here.

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
