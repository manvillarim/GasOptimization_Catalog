// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ── A (original) ────────────────────────────────────────────────────────────
contract A_MappingArray {
    uint256[] public numbers;

    function addNumber(uint256 number) public {
        numbers.push(number);
    }
}

// ── Ao (outdated) ───────────────────────────────────────────────────────────
// BUG (Solidity ≥ 0.8): `size++` reverts on overflow after 2^256-1 elements.
// The original array.push() does not overflow size (internal counter is
// also bounded, but the *revert semantics* differ in practice for checked
// arithmetic contexts).
contract Ao_MappingArray_Outdated {
    mapping(uint256 => uint256) public numbers;
    uint256 public size;

    function addNumber(uint256 number) public {
        numbers[size] = number;
        size++; // checked increment — reverts at type-max (Solidity ≥ 0.8)
    }
}

// ── Ao (updated) ─────────────────────────────────────────────────────────────
// FIX: `unchecked { size++; }` mirrors the wrap-around behaviour of the
// array's internal length counter, preserving behavioural equivalence.
contract Ao_MappingArray_Updated {
    mapping(uint256 => uint256) public numbers;
    uint256 public size;

    function addNumber(uint256 number) public {
        numbers[size] = number;
        unchecked { size++; } // matches array's unchecked length increment
    }
}