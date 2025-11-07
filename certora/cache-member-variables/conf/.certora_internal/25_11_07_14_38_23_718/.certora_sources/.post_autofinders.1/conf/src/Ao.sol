// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint[] public balances;
    bool[] public actives;
    uint[][] public transactions;
    
    function processArrays() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        uint len = balances.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,len)}
        for(uint i = 0; i < len; i++) {
            uint currentBalance = balances[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,currentBalance)}
            bool currentActive = actives[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,currentActive)}
            
            if(currentActive && currentBalance > 100) {
                currentBalance = currentBalance - 10;
                balances[i] = currentBalance;
                
                if(currentBalance < 50) {
                    currentActive = false;
                    actives[i] = currentActive;
                }
                
                uint[] storage currentTransactions = transactions[i];
                currentTransactions.push(block.timestamp);
            }
        }
    }
    
    function getLength() external view returns (uint256) {
        return balances.length;
    }
    
    function getBalanceAt(uint i) external view returns (uint256) {
        require(i < balances.length, "Index out of bounds");
        return balances[i];
    }
    
    function getActiveAt(uint i) external view returns (bool) {
        require(i < actives.length, "Index out of bounds");
        return actives[i];
    }
    
    function getTransactionsLengthAt(uint i) external view returns (uint256) {
        require(i < transactions.length, "Index out of bounds");
        return transactions[i].length;
    }
    
    function getTransactionAt(uint userIndex, uint txIndex) external view returns (uint256) {
        require(userIndex < transactions.length && txIndex < transactions[userIndex].length, "Index out of bounds");
        return transactions[userIndex][txIndex];
    }
}