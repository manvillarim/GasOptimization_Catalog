// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint[] public balances;
    bool[] public actives;
    uint[][] public transactions; // Array de arrays para simular transactions por usuário

    /*function processArrays() public {
        uint len = balances.length; // Cache do length para otimização
        for(uint i = 0; i < len; i++) {
            // Cache dos membros do array em variáveis locais para otimização de gas
            uint currentBalance = balances[i];
            bool currentActive = actives[i];
            uint[] storage currentTransactions = transactions[i]; // Referência ao array aninhado

            if(currentActive && currentBalance > 100) {
                currentBalance = currentBalance - 10;
                balances[i] = currentBalance; // Escreve de volta a variável cacheada

                if(currentBalance < 50) {
                    currentActive = false;
                    actives[i] = currentActive; // Escreve de volta a variável cacheada
                }

                // Adiciona timestamp ao array de transações do usuário 'i'
                currentTransactions.push(block.timestamp);
            }
        }
    }*/

    // Função para adicionar um novo "usuário" (conjunto de dados)
    function addUserData(uint _balance, bool _active) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016001, _active) }
        balances.push(_balance);
        actives.push(_active);
        transactions.push(new uint[](0)); // Inicializa um array de transações vazio para o novo "usuário"
    }

    // Getters (mantidos para consistência, embora o Certora possa acessar diretamente)
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