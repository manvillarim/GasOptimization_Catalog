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
            User storage user = users[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010006,0)}
            
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
            hash += users[i].balance + (users[i].active ? 1 : 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,hash)}
        }
        return hash;
    }
    
    // Função para adicionar usuários para teste
    function addUser(string memory _name, uint _balance, bool _active) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036002, _active) }
        User storage newUser = users.push();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010002,0)}
        newUser.name = _name;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020003,0)}
        newUser.balance = _balance;uint256 certora_local4 = newUser.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,certora_local4)}
        newUser.active = _active;bool certora_local5 = newUser.active;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,certora_local5)}
    }
}