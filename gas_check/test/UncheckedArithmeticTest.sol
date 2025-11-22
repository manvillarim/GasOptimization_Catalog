// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/UncheckedArithmetic.sol";

contract UncheckedArithmeticTest is Test {
    A public contractA;
    Ao public contractAo;
    
    address user1 = address(0x1);
    address user2 = address(0x2);
    address user3 = address(0x3);
    
    function setUp() public {
        vm.prank(user1);
        contractA = new A();
        
        vm.prank(user1);
        contractAo = new Ao();
    }
    
    function testTransferGasOriginal() public {
        vm.prank(user1);
        contractA.transfer(user2, 1000);
    }
    
    function testTransferGasOptimized() public {
        vm.prank(user1);
        contractAo.transfer(user2, 1000);
    }
    
    function testBatchTransferGasOriginal() public {
        address[] memory recipients = new address[](5);
        recipients[0] = user2;
        recipients[1] = user3;
        recipients[2] = address(0x4);
        recipients[3] = address(0x5);
        recipients[4] = address(0x6);
        
        vm.prank(user1);
        contractA.batchTransfer(recipients, 100);
    }
    
    function testBatchTransferGasOptimized() public {
        address[] memory recipients = new address[](5);
        recipients[0] = user2;
        recipients[1] = user3;
        recipients[2] = address(0x4);
        recipients[3] = address(0x5);
        recipients[4] = address(0x6);
        
        vm.prank(user1);
        contractAo.batchTransfer(recipients, 100);
    }
    
    function testDecrementCounterGasOriginal() public view {
        contractA.decrementCounter(100, 50);
    }
    
    function testDecrementCounterGasOptimized() public view {
        contractAo.decrementCounter(100, 50);
    }
}