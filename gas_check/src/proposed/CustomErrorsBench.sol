// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Benchmark for Rule 1 (Replace `require` with Custom Errors).
//
// WHY THREE SIZES. The saving of this rule comes from removing revert *string
// literals* from the deployed bytecode, so it is expected to scale with the
// number of guarded statements rather than with the size of the contract. The
// original single-instance measurement could not distinguish "the rule saves
// ~20% of deployment cost" from "this particular contract happened to be 20%
// revert strings". Instantiating the same contract shape at 1, 5 and 20 guards
// separates the two: a rule whose benefit is proportional to the guard count
// will show a saving that grows with k, while the per-guard saving stays flat.
//
// WHY THE GUARD BODIES ARE IDENTICAL ACROSS SIZES. Every guard tests the same
// predicate and writes the same slot, so the only quantity that varies between
// the k = 1, 5 and 20 instances is the number of revert sites. Any other
// difference in the measured gas would confound the size effect.
//
// WHY THE STRINGS ARE 32-BYTE-BOUNDED. Revert strings longer than 32 bytes
// occupy an extra word both in the constructor payload and in the revert path.
// All strings here are kept below that boundary so that the reported saving is
// a lower bound rather than an artefact of one unusually long message.

contract CE_A_1 {
    uint256 public value;

    function set(uint256 v) external {
        require(v != 0, "value must be non-zero");
        value = v;
    }
}

contract CE_Ao_1 {
    uint256 public value;

    error ValueMustBeNonZero();

    function set(uint256 v) external {
        if (v == 0) revert ValueMustBeNonZero();
        value = v;
    }
}

contract CE_A_5 {
    uint256 public value;

    function set1(uint256 v) external {
        require(v != 0, "value must be non-zero");
        value = v;
    }

    function set2(uint256 v) external {
        require(v != 1, "value must not be one");
        value = v;
    }

    function set3(uint256 v) external {
        require(v != 2, "value must not be two");
        value = v;
    }

    function set4(uint256 v) external {
        require(v != 3, "value must not be three");
        value = v;
    }

    function set5(uint256 v) external {
        require(v != 4, "value must not be four");
        value = v;
    }
}

contract CE_Ao_5 {
    uint256 public value;

    error ValueMustBeNonZero();
    error ValueMustNotBeOne();
    error ValueMustNotBeTwo();
    error ValueMustNotBeThree();
    error ValueMustNotBeFour();

    function set1(uint256 v) external {
        if (v == 0) revert ValueMustBeNonZero();
        value = v;
    }

    function set2(uint256 v) external {
        if (v == 1) revert ValueMustNotBeOne();
        value = v;
    }

    function set3(uint256 v) external {
        if (v == 2) revert ValueMustNotBeTwo();
        value = v;
    }

    function set4(uint256 v) external {
        if (v == 3) revert ValueMustNotBeThree();
        value = v;
    }

    function set5(uint256 v) external {
        if (v == 4) revert ValueMustNotBeFour();
        value = v;
    }
}

contract CE_A_20 {
    uint256 public value;

    function set(uint256 k, uint256 v) external {
        require(k != 0, "guard 00 rejected the input");
        require(k != 1, "guard 01 rejected the input");
        require(k != 2, "guard 02 rejected the input");
        require(k != 3, "guard 03 rejected the input");
        require(k != 4, "guard 04 rejected the input");
        require(k != 5, "guard 05 rejected the input");
        require(k != 6, "guard 06 rejected the input");
        require(k != 7, "guard 07 rejected the input");
        require(k != 8, "guard 08 rejected the input");
        require(k != 9, "guard 09 rejected the input");
        require(k != 10, "guard 10 rejected the input");
        require(k != 11, "guard 11 rejected the input");
        require(k != 12, "guard 12 rejected the input");
        require(k != 13, "guard 13 rejected the input");
        require(k != 14, "guard 14 rejected the input");
        require(k != 15, "guard 15 rejected the input");
        require(k != 16, "guard 16 rejected the input");
        require(k != 17, "guard 17 rejected the input");
        require(k != 18, "guard 18 rejected the input");
        require(k != 19, "guard 19 rejected the input");
        value = v;
    }
}

contract CE_Ao_20 {
    uint256 public value;

    error Guard00();
    error Guard01();
    error Guard02();
    error Guard03();
    error Guard04();
    error Guard05();
    error Guard06();
    error Guard07();
    error Guard08();
    error Guard09();
    error Guard10();
    error Guard11();
    error Guard12();
    error Guard13();
    error Guard14();
    error Guard15();
    error Guard16();
    error Guard17();
    error Guard18();
    error Guard19();

    function set(uint256 k, uint256 v) external {
        if (k == 0) revert Guard00();
        if (k == 1) revert Guard01();
        if (k == 2) revert Guard02();
        if (k == 3) revert Guard03();
        if (k == 4) revert Guard04();
        if (k == 5) revert Guard05();
        if (k == 6) revert Guard06();
        if (k == 7) revert Guard07();
        if (k == 8) revert Guard08();
        if (k == 9) revert Guard09();
        if (k == 10) revert Guard10();
        if (k == 11) revert Guard11();
        if (k == 12) revert Guard12();
        if (k == 13) revert Guard13();
        if (k == 14) revert Guard14();
        if (k == 15) revert Guard15();
        if (k == 16) revert Guard16();
        if (k == 17) revert Guard17();
        if (k == 18) revert Guard18();
        if (k == 19) revert Guard19();
        value = v;
    }
}
