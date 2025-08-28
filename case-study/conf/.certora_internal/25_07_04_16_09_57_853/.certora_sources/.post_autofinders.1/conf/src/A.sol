// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint[] public balances;
    bool[] public actives;
    uint[][] public transactions; // Array de arrays para simular transactions por usuário

    /*function processArrays() public {
        for(uint i = 0; i < balances.length; i++) {
            // Acessos diretos ineficientes
            if(actives[i] && balances[i] > 100) {
                balances[i] = balances[i] - 10;

                if(balances[i] < 50) {
                    actives[i] = false;
                }

                // Adiciona timestamp ao array de transações do usuário 'i'
                transactions[i].push(block.timestamp);
            }
        }
    }*/

    // Função para adicionar um novo "usuário" (conjunto de dados)
    function addUserData(uint _balance, bool _active) public {
        balances.push(_balance);
        actives.push(_active);
        transactions.push(new uint[](0)); // Inicializa um array de transações vazio para o novo "usuário"
    }

    // Getters para a invariante (similares aos anteriores, mas para arrays separados)
    function getLength() external view returns (uint256) {
        return balances.length; // Assumimos que todos os arrays têm o mesmo length
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