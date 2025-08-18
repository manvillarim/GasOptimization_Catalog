// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {

    struct UserData {
        address wallet;       // 20 bytes
        uint8 tier;           // 1 byte
        bool isActive;        // 1 byte
        // Total slot 0: 22 bytes (10 bytes livres)
        
        // Slot 1: uint256 (32 bytes)
        uint256 balance;      // 32 bytes
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
            wallet: _wallet,
            tier: _tier,
            isActive: true,
            balance: _initialBalance
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