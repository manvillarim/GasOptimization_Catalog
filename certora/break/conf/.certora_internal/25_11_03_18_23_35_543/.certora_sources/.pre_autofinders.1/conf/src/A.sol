// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    struct User {
        uint256 balance;
        uint256 rewards;
        bool isActive;
    }
    
    mapping(address => User) public users;
    address[] public userList;
    uint256 public totalRewards;
    uint256 public activeUserCount;
    
    function registerUser() external {
        require(!users[msg.sender].isActive, "Already registered");
        users[msg.sender] = User(0, 0, true);
        userList.push(msg.sender);
        activeUserCount++;
    }
    
    function addBalance(uint256 amount) external {
        require(users[msg.sender].isActive, "Not registered");
        users[msg.sender].balance += amount;
    }
    
    function distributeRewards(uint256 rewardPerUser) external {
        uint256 distributed = 0;
        
        for (uint256 i = 0; i < userList.length; i++) {
            address user = userList[i];
            
            // Original: usando continue
            if (!users[user].isActive) {
                continue;
            }
            
            users[user].rewards += rewardPerUser;
            distributed += rewardPerUser;
        }
        
        totalRewards += distributed;
    }
    
    function processMultipleUsers(address[] calldata targets, uint256 bonus) external {
        for (uint256 i = 0; i < targets.length; i++) {
            address user = targets[i];
            
            // Original: usando continue
            if (!users[user].isActive) {
                continue;
            }
            
            if (users[user].balance < 100) {
                continue;
            }
            
            users[user].rewards += bonus;
            totalRewards += bonus;
        }
    }
    
    function deactivateUser(address user) external {
        require(users[user].isActive, "Not active");
        users[user].isActive = false;
        activeUserCount--;
    }
    
    // View functions
    function getUserData(address user) external view returns (uint256, uint256, bool) {
        User memory u = users[user];
        return (u.balance, u.rewards, u.isActive);
    }
    
    function getUserListLength() external view returns (uint256) {
        return userList.length;
    }
}