// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    struct UserData {
        uint256 balance;      // slot 0: 32 bytes
        bool isActive;        // slot 1: 1 byte 
        uint8 tier;           // slot 2: 1 byte 
        address wallet;       // slot 3: 20 bytes 
    }
    
    mapping(uint256 => UserData) public users;
    uint256 public userCount;
    
    event UserCreated(uint256 indexed userId, address wallet);
    event UserUpdated(uint256 indexed userId);
    
    function createUser(
        address _wallet,
        uint256 _initialBalance,
        uint8 _tier
    ) external returns (uint256) {
        uint256 userId = userCount++;
        
        users[userId] = UserData({
            balance: _initialBalance,
            isActive: true,
            tier: _tier,
            wallet: _wallet
        });
        
        emit UserCreated(userId, _wallet);
        return userId;
    }
    
    function updateUser(
        uint256 _userId,
        uint256 _newBalance,
        bool _isActive,
        uint8 _tier
    ) external {
        require(_userId < userCount, "User does not exist");
        
        UserData storage user = users[_userId];
        user.balance = _newBalance;
        user.isActive = _isActive;
        user.tier = _tier;
        
        emit UserUpdated(_userId);
    }
    
    function getUserData(uint256 _userId) 
        external 
        view 
        returns (
            uint256 balance,
            bool isActive,
            uint8 tier,
            address wallet
        ) 
    {
        require(_userId < userCount, "User does not exist");
        UserData memory user = users[_userId];
        return (user.balance, user.isActive, user.tier, user.wallet);
    }
    
    function deactivateUser(uint256 _userId) external {
        require(_userId < userCount, "User does not exist");
        users[_userId].isActive = false;
    }
    
    function updateBalance(uint256 _userId, uint256 _newBalance) external {
        require(_userId < userCount, "User does not exist");
        users[_userId].balance = _newBalance;
    }
    
    function updateTier(uint256 _userId, uint8 _newTier) external {
        require(_userId < userCount, "User does not exist");
        users[_userId].tier = _newTier;
    }
    
    function getTotalInfo(uint256 _userId) 
        external 
        view 
        returns (uint256 combinedInfo) 
    {
        require(_userId < userCount, "User does not exist");
        UserData memory user = users[_userId];
        
        combinedInfo = user.balance + uint256(user.tier);
        if (user.isActive) {
            combinedInfo += 1000000;
        }
        return combinedInfo;
    }
}