// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/LoopRefactoring.sol";

contract LoopRefactoringTest is Test {
    A_LoopRefactoring           public contractA;
    Ao_LoopRefactoring_Outdated public contractAoOutdated;
    Ao_LoopRefactoring_Updated  public contractAoUpdated;

    uint constant LIMIT = 3;
    uint constant PRICE = 7;

    uint constant N_SMALL  = 100;
    uint constant N_MEDIUM = 1000;
    uint constant N_LARGE  = 5000;

    function setUp() public {
        contractA          = new A_LoopRefactoring(LIMIT, PRICE);
        contractAoOutdated = new Ao_LoopRefactoring_Outdated(LIMIT, PRICE);
        contractAoUpdated  = new Ao_LoopRefactoring_Updated(LIMIT, PRICE);
    }

    // ── N = 100 ───────────────────────────────────────────────────────────────

    function testDistributeTokensN100Original() public {
        vm.pauseGasMetering();
        contractA.seed(N_SMALL);
        vm.resumeGasMetering();
        contractA.distributeTokens();
    }

    function testDistributeTokensN100Outdated() public {
        vm.pauseGasMetering();
        contractAoOutdated.seed(N_SMALL);
        vm.resumeGasMetering();
        contractAoOutdated.distributeTokens();
    }

    function testDistributeTokensN100Updated() public {
        vm.pauseGasMetering();
        contractAoUpdated.seed(N_SMALL);
        vm.resumeGasMetering();
        contractAoUpdated.distributeTokens();
    }

    // ── N = 1000 ──────────────────────────────────────────────────────────────

    function testDistributeTokensN1000Original() public {
        vm.pauseGasMetering();
        contractA.seed(N_MEDIUM);
        vm.resumeGasMetering();
        contractA.distributeTokens();
    }

    function testDistributeTokensN1000Outdated() public {
        vm.pauseGasMetering();
        contractAoOutdated.seed(N_MEDIUM);
        vm.resumeGasMetering();
        contractAoOutdated.distributeTokens();
    }

    function testDistributeTokensN1000Updated() public {
        vm.pauseGasMetering();
        contractAoUpdated.seed(N_MEDIUM);
        vm.resumeGasMetering();
        contractAoUpdated.distributeTokens();
    }

    // ── N = 5000 ──────────────────────────────────────────────────────────────

    function testDistributeTokensN5000Original() public {
        vm.pauseGasMetering();
        contractA.seed(N_LARGE);
        vm.resumeGasMetering();
        contractA.distributeTokens();
    }

    function testDistributeTokensN5000Outdated() public {
        vm.pauseGasMetering();
        contractAoOutdated.seed(N_LARGE);
        vm.resumeGasMetering();
        contractAoOutdated.distributeTokens();
    }

    function testDistributeTokensN5000Updated() public {
        vm.pauseGasMetering();
        contractAoUpdated.seed(N_LARGE);
        vm.resumeGasMetering();
        contractAoUpdated.distributeTokens();
    }

    // ── behavioural: empty array + overflow ──────────────────────────────────

    function testEmptyArrayOriginalNoRevert() public {
        A_LoopRefactoring c = new A_LoopRefactoring(type(uint).max, 2);
        c.distributeTokens();
    }

    function testEmptyArrayOutdatedReverts() public {
        Ao_LoopRefactoring_Outdated c = new Ao_LoopRefactoring_Outdated(type(uint).max, 2);
        vm.expectRevert();
        c.distributeTokens();
    }

    function testEmptyArrayUpdatedNoRevert() public {
        Ao_LoopRefactoring_Updated c = new Ao_LoopRefactoring_Updated(type(uint).max, 2);
        c.distributeTokens();
    }

    // ── state equivalence ─────────────────────────────────────────────────────

    function testStateEquivalenceOriginalVsUpdated() public {
        vm.pauseGasMetering();
        contractA.seed(N_SMALL);
        contractAoUpdated.seed(N_SMALL);
        vm.resumeGasMetering();

        contractA.distributeTokens();
        contractAoUpdated.distributeTokens();

        vm.pauseGasMetering();
        for (uint i = 0; i < N_SMALL; i++) {
            assertEq(contractA.tokens(i), contractAoUpdated.tokens(i));
        }
    }
}