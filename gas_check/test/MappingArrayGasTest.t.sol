// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MappingArray.sol";

contract MappingArrayTest is Test {
    A_MappingArray           public contractA;
    Ao_MappingArray_Outdated public contractAoOutdated;
    Ao_MappingArray_Updated  public contractAoUpdated;

    address user1 = address(0x1);

    uint constant N_SMALL  = 50;
    uint constant N_MEDIUM = 500;
    uint constant N_LARGE  = 2000;

    function setUp() public {
        vm.prank(user1);
        contractA = new A_MappingArray();
        vm.prank(user1);
        contractAoOutdated = new Ao_MappingArray_Outdated();
        vm.prank(user1);
        contractAoUpdated  = new Ao_MappingArray_Updated();
    }

    // ── single insert (cold) ──────────────────────────────────────────────────

    function testAddNumberGasOriginal() public {
        vm.prank(user1);
        contractA.addNumber(42);
    }

    function testAddNumberGasOutdated() public {
        vm.prank(user1);
        contractAoOutdated.addNumber(42);
    }

    function testAddNumberGasUpdated() public {
        vm.prank(user1);
        contractAoUpdated.addNumber(42);
    }

    // ── single insert (warm) ──────────────────────────────────────────────────

    function testAddNumberWarmGasOriginal() public {
        vm.pauseGasMetering();
        vm.prank(user1);
        contractA.addNumber(1);
        vm.resumeGasMetering();
        vm.prank(user1);
        contractA.addNumber(2);
    }

    function testAddNumberWarmGasOutdated() public {
        vm.pauseGasMetering();
        vm.prank(user1);
        contractAoOutdated.addNumber(1);
        vm.resumeGasMetering();
        vm.prank(user1);
        contractAoOutdated.addNumber(2);
    }

    function testAddNumberWarmGasUpdated() public {
        vm.pauseGasMetering();
        vm.prank(user1);
        contractAoUpdated.addNumber(1);
        vm.resumeGasMetering();
        vm.prank(user1);
        contractAoUpdated.addNumber(2);
    }

    // ── bulk N = 50 ───────────────────────────────────────────────────────────

    function testBulkN50GasOriginal() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_SMALL; i++) contractA.addNumber(i);
        vm.stopPrank();
    }

    function testBulkN50GasOutdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_SMALL; i++) contractAoOutdated.addNumber(i);
        vm.stopPrank();
    }

    function testBulkN50GasUpdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_SMALL; i++) contractAoUpdated.addNumber(i);
        vm.stopPrank();
    }

    // ── bulk N = 500 ──────────────────────────────────────────────────────────

    function testBulkN500GasOriginal() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_MEDIUM; i++) contractA.addNumber(i);
        vm.stopPrank();
    }

    function testBulkN500GasOutdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_MEDIUM; i++) contractAoOutdated.addNumber(i);
        vm.stopPrank();
    }

    function testBulkN500GasUpdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_MEDIUM; i++) contractAoUpdated.addNumber(i);
        vm.stopPrank();
    }

    // ── bulk N = 2000 ─────────────────────────────────────────────────────────

    function testBulkN2000GasOriginal() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_LARGE; i++) contractA.addNumber(i);
        vm.stopPrank();
    }

    function testBulkN2000GasOutdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_LARGE; i++) contractAoOutdated.addNumber(i);
        vm.stopPrank();
    }

    function testBulkN2000GasUpdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_LARGE; i++) contractAoUpdated.addNumber(i);
        vm.stopPrank();
    }

    // ── state equivalence ─────────────────────────────────────────────────────

    function testStateEquivalenceOriginalVsUpdated() public {
        vm.startPrank(user1);
        for (uint i = 0; i < N_SMALL; i++) {
            contractA.addNumber(i * 3);
            contractAoUpdated.addNumber(i * 3);
        }
        vm.stopPrank();

        for (uint i = 0; i < N_SMALL; i++) {
            assertEq(contractA.numbers(i), contractAoUpdated.numbers(i));
        }
        assertEq(contractAoUpdated.size(), N_SMALL);
    }

    // ── behavioural: size overflow ────────────────────────────────────────────

    function testSizeOverflowOutdatedReverts() public {
        vm.store(address(contractAoOutdated), bytes32(uint256(1)), bytes32(type(uint256).max));
        assertEq(contractAoOutdated.size(), type(uint256).max);
        vm.expectRevert();
        vm.prank(user1);
        contractAoOutdated.addNumber(1);
    }

    function testSizeOverflowUpdatedWraps() public {
        vm.store(address(contractAoUpdated), bytes32(uint256(1)), bytes32(type(uint256).max));
        assertEq(contractAoUpdated.size(), type(uint256).max);
        vm.prank(user1);
        contractAoUpdated.addNumber(1);
        assertEq(contractAoUpdated.size(), 0);
    }
}