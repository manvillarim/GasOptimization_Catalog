//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract A {
    struct User {
        string name;
        uint balance;
        bool active;
        uint[] transactions;
    }
    
    User[] public users;
    
    function processUsers() public {
        for(uint i = 0; i < users.length; i++) {
            // Multiple accesses to same array member - INEFICIENTE
            if(users[i].active && users[i].balance > 100) {
                users[i].balance = users[i].balance - 10;
                
                if(users[i].balance < 50) {
                    users[i].active = false;
                }
                
                users[i].transactions.push(block.timestamp);
            }
        }
    }
    
    function getData() external view returns (uint256) {
        uint256 hash = 0;
        for(uint i = 0; i < users.length; i++) {
            hash += users[i].balance + (users[i].active ? 1 : 0);
        }
        return hash;
    }
    
    // Função para adicionar usuários para teste
    function addUser(string memory _name, uint _balance, bool _active) public {
        User storage newUser = users.push();
        newUser.name = _name;
        newUser.balance = _balance;
        newUser.active = _active;
    }

    function getUsersLength() external view returns (uint256) {
    return users.length;
}

function getTotalBalance() external view returns (uint256) {
    uint256 total = 0;
    for(uint i = 0; i < users.length; i++) {
        total += users[i].balance;
    }
    return total;
}

function getActiveCount() external view returns (uint256) {
    uint256 count = 0;
    for(uint i = 0; i < users.length; i++) {
        if(users[i].active) count++;
    }
    return count;
}

}