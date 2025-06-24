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
    
    function processUsers() public {
        for(uint i = 0; i < users.length; i++) {

            User storage user = users[i];
            
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