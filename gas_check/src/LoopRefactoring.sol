// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ── A (original) ────────────────────────────────────────────────────────────
contract A_LoopRefactoring {
    uint[] public tokens;
    uint public limit;
    uint public price;

    constructor(uint _limit, uint _price) {
        limit = _limit;
        price = _price;
    }

    function seed(uint n) external {
        for (uint i = 0; i < n; i++) tokens.push(0);
    }

    /// @dev limit * price is recomputed every iteration
    function distributeTokens() external {
        uint length = tokens.length;
        for (uint i = 0; i < length; i++) {
            tokens[i] += limit * price;
        }
    }
}

// ── Ao (outdated) ───────────────────────────────────────────────────────────
// BUG (Solidity ≥ 0.8): if length == 0 and limit * price overflows,
// this reverts whereas A_LoopRefactoring does not.
contract Ao_LoopRefactoring_Outdated {
    uint[] public tokens;
    uint public limit;
    uint public price;

    constructor(uint _limit, uint _price) {
        limit = _limit;
        price = _price;
    }

    function seed(uint n) external {
        for (uint i = 0; i < n; i++) tokens.push(0);
    }

    /// @dev amount = limit * price is hoisted out of the loop (no guard)
    function distributeTokens() external {
        uint length = tokens.length;
        uint amount = limit * price; // overflows if length == 0 → revert (≥0.8)
        for (uint i = 0; i < length; i++) {
            tokens[i] += amount;
        }
    }
}

// ── Ao (updated) ─────────────────────────────────────────────────────────────
// FIX: guard `if (length > 0)` avoids the spurious overflow when length == 0.
contract Ao_LoopRefactoring_Updated {
    uint[] public tokens;
    uint public limit;
    uint public price;

    constructor(uint _limit, uint _price) {
        limit = _limit;
        price = _price;
    }

    function seed(uint n) external {
        for (uint i = 0; i < n; i++) tokens.push(0);
    }

    /// @dev Correctly hoists limit * price with a length guard
    function distributeTokens() external {
        uint length = tokens.length;
        if (length > 0) {
            uint amount = limit * price;
            for (uint i = 0; i < length; i++) {
                tokens[i] += amount;
            }
        }
    }
}