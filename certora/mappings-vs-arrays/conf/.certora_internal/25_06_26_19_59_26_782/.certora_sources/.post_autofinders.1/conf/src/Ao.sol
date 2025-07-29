//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;


contract Ao {
    struct User {
        string name;
        uint balance;
        bool active;
        uint[] transactions;
    }
    
    User[] public users;
    
    function processUsers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) }
        for(uint i = 0; i < users.length; i++) {
            // Cache array member in local variable - OTIMIZADO
            User storage user = users[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010008,0)}
            
            if(user.active && user.balance > 100) {
                user.balance = user.balance - 10;
                
                if(user.balance < 50) {
                    user.active = false;
                }
                
                user.transactions.push(block.timestamp);
            }
        }
    }
    
    function getData() external view returns (uint256) {
        uint256 hash = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,hash)}
        for(uint i = 0; i < users.length; i++) {
            hash += users[i].balance + (users[i].active ? 1 : 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,hash)}
        }
        return hash;
    }
    
    // Função para adicionar usuários para teste
    function addUser(string memory _name, uint _balance, bool _active) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036002, _active) }
        User storage newUser = users.push();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010002,0)}
        newUser.name = _name;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020005,0)}
        newUser.balance = _balance;uint256 certora_local6 = newUser.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,certora_local6)}
        newUser.active = _active;bool certora_local7 = newUser.active;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,certora_local7)}
    }

    function getUsersLength() external view returns (uint256) {
    return users.length;
}

function getTotalBalance() external view returns (uint256) {
    uint256 total = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,total)}
    for(uint i = 0; i < users.length; i++) {
        total += users[i].balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,total)}
    }
    return total;
}

function getActiveCount() external view returns (uint256) {
    uint256 count = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,count)}
    for(uint i = 0; i < users.length; i++) {
        if(users[i].active) count++;
    }
    return count;
}


}