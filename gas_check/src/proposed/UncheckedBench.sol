// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 28 (Use `unchecked` arithmetic for validated operations).
//
// WHY A LOOP PARAMETERISED BY N. The saving of this rule is one elided
// overflow check per arithmetic operation, so it is expected to be linear in
// the number of executed operations and essentially absent from deployment
// cost beyond the removed check code. Measuring a single fixed workload cannot
// tell a per-operation saving from a one-off one. N in {100, 1000, 5000}
// mirrors the sweep already used for the loop-refactoring pattern, so the two
// results are directly comparable.
//
// WHY THE GUARD IS HOISTED OUT OF THE LOOP. `unchecked` is only sound here
// because `start >= iterations` is established before the loop, which makes
// every decrement in the body non-negative by construction. Keeping the
// validation outside the measured body is also what makes the two versions
// differ in exactly one respect: the presence of the redundant per-iteration
// check.
//
// WHY EACH SEEDED SLOT HOLDS 1. With `n <= 5000` enforced and every slot equal
// to one, the accumulator is bounded by 5000 and the elided overflow check is
// unreachable by construction, so the two versions are equivalent on every
// input rather than only on the inputs exercised here.
//
// WHY SETUP IS SEPARATED FROM MEASUREMENT. The array-populating variant below
// writes N storage slots before the measured call. Those SSTOREs cost orders
// of magnitude more than the arithmetic under study, and in the original
// benchmark they were inside the metered region, which diluted the reported
// saving towards zero. The tests pause gas metering around `seed` and resume
// immediately before the measured call.

contract UA_A {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed(uint256 n) external {
        for (uint256 i = 0; i < n; i++) {
            slots[i] = 1;
        }
    }

    function decrementLoop(uint256 start, uint256 iterations) external returns (uint256) {
        require(start >= iterations, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < iterations; i++) {
            counter -= 1;
        }
        sink = counter;
        return counter;
    }

    function accumulate(uint256 n) external returns (uint256) {
        require(n <= 5000, "n out of range");

        uint256 total;
        for (uint256 i = 0; i < n; i++) {
            total += slots[i];
        }
        sink = total;
        return total;
    }
}

contract UA_Ao {
    mapping(uint256 => uint256) public slots;
    uint256 public sink;

    function seed(uint256 n) external {
        for (uint256 i = 0; i < n; i++) {
            slots[i] = 1;
        }
    }

    function decrementLoop(uint256 start, uint256 iterations) external returns (uint256) {
        require(start >= iterations, "start must be >= iterations");

        uint256 counter = start;
        for (uint256 i = 0; i < iterations; i++) {
            unchecked {
                counter -= 1;
            }
        }
        sink = counter;
        return counter;
    }

    function accumulate(uint256 n) external returns (uint256) {
        require(n <= 5000, "n out of range");

        uint256 total;
        for (uint256 i = 0; i < n; i++) {
            unchecked {
                total += slots[i];
            }
        }
        sink = total;
        return total;
    }
}
