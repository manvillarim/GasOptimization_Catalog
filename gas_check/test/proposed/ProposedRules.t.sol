// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {CE_A_1, CE_Ao_1, CE_A_5, CE_Ao_5, CE_A_20, CE_Ao_20} from "../../src/proposed/CustomErrorsBench.sol";
import {
    UA_A_Arith100,
    UA_Ao_Arith100,
    UA_A_Arith1000,
    UA_Ao_Arith1000,
    UA_A_Arith5000,
    UA_Ao_Arith5000,
    UA_A_Sload100,
    UA_Ao_Sload100,
    UA_A_Sload1000,
    UA_Ao_Sload1000,
    UA_A_Sload5000,
    UA_Ao_Sload5000
} from "../../src/proposed/UncheckedBench.sol";
import {
    PC_A_Min,
    PC_Ao_Min,
    PC_A_Simple,
    PC_Ao_Simple,
    PC_A_Heavy,
    PC_Ao_Heavy
} from "../../src/proposed/PayableCtorBench.sol";

// Deployment cost and size are read from `forge test --gas-report`; function
// cost is read from the per-test gas figure. Each test makes exactly one
// metered call, and its name identifies the datum for the extraction in
// `script/run_benchmark.sh`.

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

contract UncheckedArith100 is Test {
    UA_A_Arith100 internal a;
    UA_Ao_Arith100 internal ao;

    function setUp() public {
        a = new UA_A_Arith100();
        ao = new UA_Ao_Arith100();
    }

    function test_Unchecked_arith100_A_loop() public {
        a.run(100);
    }

    function test_Unchecked_arith100_Ao_loop() public {
        ao.run(100);
    }
}

contract UncheckedArith1000 is Test {
    UA_A_Arith1000 internal a;
    UA_Ao_Arith1000 internal ao;

    function setUp() public {
        a = new UA_A_Arith1000();
        ao = new UA_Ao_Arith1000();
    }

    function test_Unchecked_arith1000_A_loop() public {
        a.run(1000);
    }

    function test_Unchecked_arith1000_Ao_loop() public {
        ao.run(1000);
    }
}

contract UncheckedArith5000 is Test {
    UA_A_Arith5000 internal a;
    UA_Ao_Arith5000 internal ao;

    function setUp() public {
        a = new UA_A_Arith5000();
        ao = new UA_Ao_Arith5000();
    }

    function test_Unchecked_arith5000_A_loop() public {
        a.run(5000);
    }

    function test_Unchecked_arith5000_Ao_loop() public {
        ao.run(5000);
    }
}

// Seeding the N slots is kept out of the metered region.
contract UncheckedSload100 is Test {
    UA_A_Sload100 internal a;
    UA_Ao_Sload100 internal ao;

    function setUp() public {
        a = new UA_A_Sload100();
        ao = new UA_Ao_Sload100();
    }

    function test_Unchecked_sload100_A_loop() public {
        vm.pauseGasMetering();
        a.seed();
        vm.resumeGasMetering();
        a.run();
    }

    function test_Unchecked_sload100_Ao_loop() public {
        vm.pauseGasMetering();
        ao.seed();
        vm.resumeGasMetering();
        ao.run();
    }
}

// Seeding the N slots is kept out of the metered region.
contract UncheckedSload1000 is Test {
    UA_A_Sload1000 internal a;
    UA_Ao_Sload1000 internal ao;

    function setUp() public {
        a = new UA_A_Sload1000();
        ao = new UA_Ao_Sload1000();
    }

    function test_Unchecked_sload1000_A_loop() public {
        vm.pauseGasMetering();
        a.seed();
        vm.resumeGasMetering();
        a.run();
    }

    function test_Unchecked_sload1000_Ao_loop() public {
        vm.pauseGasMetering();
        ao.seed();
        vm.resumeGasMetering();
        ao.run();
    }
}

// Seeding the N slots is kept out of the metered region.
contract UncheckedSload5000 is Test {
    UA_A_Sload5000 internal a;
    UA_Ao_Sload5000 internal ao;

    function setUp() public {
        a = new UA_A_Sload5000();
        ao = new UA_Ao_Sload5000();
    }

    function test_Unchecked_sload5000_A_loop() public {
        vm.pauseGasMetering();
        a.seed();
        vm.resumeGasMetering();
        a.run();
    }

    function test_Unchecked_sload5000_Ao_loop() public {
        vm.pauseGasMetering();
        ao.seed();
        vm.resumeGasMetering();
        ao.run();
    }
}

contract PayableCtorMinimal is Test {
    PC_A_Min internal a;
    PC_Ao_Min internal ao;

    // Deployed here and called once so the gas report emits a row for each.
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
