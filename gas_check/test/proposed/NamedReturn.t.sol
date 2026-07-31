// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {
    NR_A_One,
    NR_Ao_One,
    NR_A_Three,
    NR_Ao_Three,
    NR_A_Struct,
    NR_Ao_Struct
} from "../../src/proposed/NamedReturnBench.sol";

contract NamedReturnOneA is Test {
    NR_A_One internal c;

    function setUp() public {
        c = new NR_A_One();
    }

    function test_NamedReturn_one_A_get() public view {
        c.get(1, 3);
    }
}

contract NamedReturnOneAo is Test {
    NR_Ao_One internal c;

    function setUp() public {
        c = new NR_Ao_One();
    }

    function test_NamedReturn_one_Ao_get() public view {
        c.get(1, 3);
    }
}

contract NamedReturnThreeA is Test {
    NR_A_Three internal c;

    function setUp() public {
        c = new NR_A_Three();
    }

    function test_NamedReturn_three_A_get() public view {
        c.get(1);
    }
}

contract NamedReturnThreeAo is Test {
    NR_Ao_Three internal c;

    function setUp() public {
        c = new NR_Ao_Three();
    }

    function test_NamedReturn_three_Ao_get() public view {
        c.get(1);
    }
}

contract NamedReturnStructA is Test {
    NR_A_Struct internal c;

    function setUp() public {
        c = new NR_A_Struct();
    }

    function test_NamedReturn_struct_A_get() public view {
        c.get(1);
    }
}

contract NamedReturnStructAo is Test {
    NR_Ao_Struct internal c;

    function setUp() public {
        c = new NR_Ao_Struct();
    }

    function test_NamedReturn_struct_Ao_get() public view {
        c.get(1);
    }
}

