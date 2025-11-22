// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ReplaceRequireWithCustomErrors.sol";

contract ReplaceRequireWithCustomErrorsTest is Test {
    A public contractA;
    Ao public contractAo;
    
    address user1 = address(0x1);
    address user2 = address(0x2);
    
    function setUp() public {
        contractA = new A();
        contractAo = new Ao();
        
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }
    
    function testDepositGasOriginal() public {
        vm.prank(user1);
        contractA.deposit{value: 1 ether}();
    }
    
    function testDepositGasOptimized() public {
        vm.prank(user1);
        contractAo.deposit{value: 1 ether}();
    }
    
    function testWithdrawGasOriginal() public {
        vm.prank(user1);
        contractA.deposit{value: 1 ether}();
        
        vm.prank(user1);
        contractA.withdraw(0.5 ether);
    }
    
    function testWithdrawGasOptimized() public {
        vm.prank(user1);
        contractAo.deposit{value: 1 ether}();
        
        vm.prank(user1);
        contractAo.withdraw(0.5 ether);
    }
    
    function testTransferGasOriginal() public {
        vm.prank(user1);
        contractA.deposit{value: 1 ether}();
        
        vm.prank(user1);
        contractA.transfer(user2, 0.5 ether);
    }
    
    function testTransferGasOptimized() public {
        vm.prank(user1);
        contractAo.deposit{value: 1 ether}();
        
        vm.prank(user1);
        contractAo.transfer(user2, 0.5 ether);
    }
    
    function testRevertDepositGasOriginal() public {
        vm.prank(user1);
        vm.expectRevert("Deposit amount must be greater than zero");
        contractA.deposit{value: 0}();
    }
    
    function testRevertDepositGasOptimized() public {
        vm.prank(user1);
        vm.expectRevert(Ao.DepositAmountMustBeGreaterThanZero.selector);
        contractAo.deposit{value: 0}();
    }
}