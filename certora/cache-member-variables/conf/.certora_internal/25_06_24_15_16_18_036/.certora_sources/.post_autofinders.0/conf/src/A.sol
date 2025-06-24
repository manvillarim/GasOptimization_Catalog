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
    
    function processUsers() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        for(uint i = 0; i < users.length; i++) {
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
        return users.length;
    }
    
    function getUsersLength() external view returns (uint256) {
        return users.length;
    }

    function getUserBalance(uint256 index) external view returns (uint256) {
    return users[index].balance;
}

function getUserActive(uint256 index) external view returns (bool) {
    return users[index].active;
}


}