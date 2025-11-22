// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/PayableConstructor.sol";

contract PayableConstructorTest is Test {
    address testOwner = address(0x1234);
    uint256 testValue = 100;
    string testName = "TestContract";

    function testDeploymentGasOriginal() public {
        new A(testOwner, testValue, testName);
    }

    function testDeploymentGasOptimized() public {
        new Ao(testOwner, testValue, testName);
    }

    function testBothContractsBehaveSame() public {
        A contractA = new A(testOwner, testValue, testName);
        Ao contractAo = new Ao(testOwner, testValue, testName);

        assertEq(contractA.owner(), contractAo.owner());
        assertEq(contractA.value(), contractAo.value());
        assertEq(contractA.name(), contractAo.name());
        assertEq(contractA.getValue(), contractAo.getValue());
    }
}