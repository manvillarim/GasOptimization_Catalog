// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {CE_A_1, CE_Ao_1, CE_A_5, CE_Ao_5, CE_A_20, CE_Ao_20} from "../../src/proposed/CustomErrorsBench.sol";
import {UA_A, UA_Ao} from "../../src/proposed/UncheckedBench.sol";
import {
    PC_A_Min,
    PC_Ao_Min,
    PC_A_Simple,
    PC_Ao_Simple,
    PC_A_Heavy,
    PC_Ao_Heavy
} from "../../src/proposed/PayableCtorBench.sol";

// MEASUREMENT PROTOCOL
//
// Deployment cost and deployment size are read from `forge test --gas-report`,
// which reports the CREATE gas and the runtime code length per contract. This
// is the same instrument used for every other gas figure in the paper, so the
// numbers are directly comparable.
//
// Function cost is read from the per-test gas figure that forge prints for each
// test case, with `vm.pauseGasMetering` wrapping everything that is not the
// operation under study. Each measured test therefore contains exactly one
// metered call. This is the protocol already used for the loop-refactoring
// benchmark; the original proposed-rules benchmark did not use it, which is one
// of the defects this reconstruction corrects.
//
// One measured call per test also means the test name identifies the datum
// unambiguously, which is what the CSV extraction in `script/run_benchmark.sh`
// relies on.

contract CustomErrorsK1 is Test {
    CE_A_1 internal a;
    CE_Ao_1 internal ao;

    function setUp() public {
        a = new CE_A_1();
        ao = new CE_Ao_1();
    }

    function test_CustomErrors_k1_A_set() public {
        a.set(7);
    }

    function test_CustomErrors_k1_Ao_set() public {
        ao.set(7);
    }
}

contract CustomErrorsK5 is Test {
    CE_A_5 internal a;
    CE_Ao_5 internal ao;

    function setUp() public {
        a = new CE_A_5();
        ao = new CE_Ao_5();
    }

    function test_CustomErrors_k5_A_set() public {
        a.set1(7);
    }

    function test_CustomErrors_k5_Ao_set() public {
        ao.set1(7);
    }
}

contract CustomErrorsK20 is Test {
    CE_A_20 internal a;
    CE_Ao_20 internal ao;

    function setUp() public {
        a = new CE_A_20();
        ao = new CE_Ao_20();
    }

    function test_CustomErrors_k20_A_set() public {
        a.set(99, 7);
    }

    function test_CustomErrors_k20_Ao_set() public {
        ao.set(99, 7);
    }
}

contract UncheckedArithmetic is Test {
    UA_A internal a;
    UA_Ao internal ao;

    uint256 constant N_SMALL = 100;
    uint256 constant N_MEDIUM = 1000;
    uint256 constant N_LARGE = 5000;

    function setUp() public {
        a = new UA_A();
        ao = new UA_Ao();
    }

    function test_Unchecked_N100_A_decrement() public {
        a.decrementLoop(N_SMALL, N_SMALL);
    }

    function test_Unchecked_N100_Ao_decrement() public {
        ao.decrementLoop(N_SMALL, N_SMALL);
    }

    function test_Unchecked_N1000_A_decrement() public {
        a.decrementLoop(N_MEDIUM, N_MEDIUM);
    }

    function test_Unchecked_N1000_Ao_decrement() public {
        ao.decrementLoop(N_MEDIUM, N_MEDIUM);
    }

    function test_Unchecked_N5000_A_decrement() public {
        a.decrementLoop(N_LARGE, N_LARGE);
    }

    function test_Unchecked_N5000_Ao_decrement() public {
        ao.decrementLoop(N_LARGE, N_LARGE);
    }

    function test_Unchecked_N100_A_accumulate() public {
        vm.pauseGasMetering();
        a.seed(N_SMALL);
        vm.resumeGasMetering();
        a.accumulate(N_SMALL);
    }

    function test_Unchecked_N100_Ao_accumulate() public {
        vm.pauseGasMetering();
        ao.seed(N_SMALL);
        vm.resumeGasMetering();
        ao.accumulate(N_SMALL);
    }

    function test_Unchecked_N1000_A_accumulate() public {
        vm.pauseGasMetering();
        a.seed(N_MEDIUM);
        vm.resumeGasMetering();
        a.accumulate(N_MEDIUM);
    }

    function test_Unchecked_N1000_Ao_accumulate() public {
        vm.pauseGasMetering();
        ao.seed(N_MEDIUM);
        vm.resumeGasMetering();
        ao.accumulate(N_MEDIUM);
    }

    function test_Unchecked_N5000_A_accumulate() public {
        vm.pauseGasMetering();
        a.seed(N_LARGE);
        vm.resumeGasMetering();
        a.accumulate(N_LARGE);
    }

    function test_Unchecked_N5000_Ao_accumulate() public {
        vm.pauseGasMetering();
        ao.seed(N_LARGE);
        vm.resumeGasMetering();
        ao.accumulate(N_LARGE);
    }
}

contract PayableCtorMinimal is Test {
    PC_A_Min internal a;
    PC_Ao_Min internal ao;

    // The two instances are also deployed in setUp and then called once, so
    // that the gas report emits a deployment-cost and runtime-size row for
    // each. A contract that is only constructed inside a test body never
    // receives a call and is therefore absent from the report.
    function setUp() public {
        a = new PC_A_Min();
        ao = new PC_Ao_Min();
    }

    function test_PayableCtor_min_A_deploy() public {
        new PC_A_Min();
    }

    function test_PayableCtor_min_Ao_deploy() public {
        new PC_Ao_Min();
    }

    function test_PayableCtor_min_A_touch() public {
        a.bump();
    }

    function test_PayableCtor_min_Ao_touch() public {
        ao.bump();
    }
}

contract PayableCtorSimple is Test {
    address constant OWNER = address(0x1234);

    function test_PayableCtor_simple_A_deploy() public {
        new PC_A_Simple(OWNER, 100, "TestContract");
    }

    function test_PayableCtor_simple_Ao_deploy() public {
        new PC_Ao_Simple(OWNER, 100, "TestContract");
    }
}

contract PayableCtorHeavy is Test {
    address constant OWNER = address(0x1234);
    uint256 constant SLOTS = 64;

    PC_A_Heavy internal a;
    PC_Ao_Heavy internal ao;

    function setUp() public {
        a = new PC_A_Heavy(OWNER, 100, "TestContract", SLOTS);
        ao = new PC_Ao_Heavy(OWNER, 100, "TestContract", SLOTS);
    }

    function test_PayableCtor_heavy_A_deploy() public {
        new PC_A_Heavy(OWNER, 100, "TestContract", SLOTS);
    }

    function test_PayableCtor_heavy_Ao_deploy() public {
        new PC_Ao_Heavy(OWNER, 100, "TestContract", SLOTS);
    }

    function test_PayableCtor_heavy_A_touch() public {
        a.bump();
    }

    function test_PayableCtor_heavy_Ao_touch() public {
        ao.bump();
    }
}

contract PayableCtorRuntimeControl is Test {
    PC_A_Simple internal a;
    PC_Ao_Simple internal ao;

    function setUp() public {
        a = new PC_A_Simple(address(0x1234), 100, "TestContract");
        ao = new PC_Ao_Simple(address(0x1234), 100, "TestContract");
    }

    function test_PayableCtor_runtime_A_bump() public {
        a.bump();
    }

    function test_PayableCtor_runtime_Ao_bump() public {
        ao.bump();
    }
}
