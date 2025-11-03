using A as a;
using Ao as ao;

methods {
    function a.registerUser() external;
    function a.removeUser(address) external;
    function a.processTransaction(address, uint256) external;
    function a.clearOldTransactions(uint256) external;
    function a.resetUserRewards(address) external;
    function a.getUserData(address) external returns (uint256, bool, uint256, uint256);
    
    function a.balances(address) external returns (uint256) envfree;
    function a.isRegistered(address) external returns (bool) envfree;
    function a.lastActivityTime(address) external returns (uint256) envfree;
    function a.rewardPoints(address) external returns (uint256) envfree;
    function a.allUsers(uint256) external returns (address) envfree;
    function a.userIndex(address) external returns (uint256) envfree;
    function a.totalUsers() external returns (uint256) envfree;
    function a.totalBalance() external returns (uint256) envfree;
    function a.rewardPool() external returns (uint256) envfree;
    function a.transactionSenders(uint256) external returns (address) envfree;
    function a.transactionAmounts(uint256) external returns (uint256) envfree;
    function a.transactionTimestamps(uint256) external returns (uint256) envfree;
    function a.transactionCount() external returns (uint256) envfree;
    

    function ao.registerUser() external;
    function ao.removeUser(address) external;
    function ao.processTransaction(address, uint256) external;
    function ao.clearOldTransactions(uint256) external;
    function ao.resetUserRewards(address) external;
    function ao.cleanupInactiveUsers(address[], uint256) external;
    function ao.getUserData(address) external returns (uint256, bool, uint256, uint256);
    function ao.getActiveTransactionCount() external returns (uint256) envfree;
    
    function ao.balances(address) external returns (uint256) envfree;
    function ao.isRegistered(address) external returns (bool) envfree;
    function ao.lastActivityTime(address) external returns (uint256) envfree;
    function ao.rewardPoints(address) external returns (uint256) envfree;
    function ao.allUsers(uint256) external returns (address) envfree;
    function ao.userIndex(address) external returns (uint256) envfree;
    function ao.totalUsers() external returns (uint256) envfree;
    function ao.totalBalance() external returns (uint256) envfree;
    function ao.rewardPool() external returns (uint256) envfree;
    function ao.transactionSenders(uint256) external returns (address) envfree;
    function ao.transactionAmounts(uint256) external returns (uint256) envfree;
    function ao.transactionTimestamps(uint256) external returns (uint256) envfree;
    function ao.transactionCount() external returns (uint256) envfree;
    function ao.oldestTransactionIndex() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.totalUsers == ao.totalUsers &&
    a.totalBalance == ao.totalBalance &&
    a.rewardPool == ao.rewardPool &&
    a.transactionCount == ao.transactionCount &&
    a.allUsers.length == ao.allUsers.length &&
    (forall uint256 i. (i < a.allUsers.length => (
        a.allUsers[i] == ao.allUsers[i] &&
        a.isRegistered[a.allUsers[i]] == ao.isRegistered[ao.allUsers[i]]
    ))) &&
    (forall address user. (
        a.isRegistered[user] == ao.isRegistered[user] &&
        a.balances[user] == ao.balances[user] &&
        a.lastActivityTime[user] == ao.lastActivityTime[user] &&
        a.rewardPoints[user] == ao.rewardPoints[user] &&
        (a.isRegistered[user] => a.userIndex[user] == ao.userIndex[user])
    ));

definition removedUserStateEquivalent(address user) returns bool =
    (!a.isRegistered[user] && !ao.isRegistered[user]) &&
    (a.balances[user] == ao.balances[user]) &&
    (a.rewardPoints[user] == ao.rewardPoints[user]);

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfRegisterUser(method f, method g)
filtered {
    f -> f.selector == sig:a.registerUser().selector,
    g -> g.selector == sig:ao.registerUser().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfRemoveUser(method f, method g)
filtered {
    f -> f.selector == sig:a.removeUser(address).selector,
    g -> g.selector == sig:ao.removeUser(address).selector
} {
    env eA;
    env eAo;
    address userToRemove;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    bool wasRegistered = a.isRegistered[userToRemove];
    
    a.removeUser(eA, userToRemove);
    ao.removeUser(eAo, userToRemove);
    
    assert couplingInv();
    
    assert wasRegistered => removedUserStateEquivalent(userToRemove);
}

rule gasOptimizedCorrectnessOfProcessTransaction(method f, method g)
filtered {
    f -> f.selector == sig:a.processTransaction(address,uint256).selector,
    g -> g.selector == sig:ao.processTransaction(address,uint256).selector
} {
    env eA;
    env eAo;
    address to;
    uint256 amount;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    uint256 senderBalanceBefore = a.balances[eA.msg.sender];
    uint256 toBalanceBefore = a.balances[to];
    
    a.processTransaction(eA, to, amount);
    ao.processTransaction(eAo, to, amount);
    
    assert couplingInv();
    
    assert a.balances[eA.msg.sender] == ao.balances[eAo.msg.sender];
    assert a.balances[to] == ao.balances[to];
}

rule gasOptimizedCorrectnessOfClearOldTransactions(method f, method g)
filtered {
    f -> f.selector == sig:a.clearOldTransactions(uint256).selector,
    g -> g.selector == sig:ao.clearOldTransactions(uint256).selector
} {
    env eA;
    env eAo;
    uint256 beforeIndex;
    
    require eA.msg.sender == eAo.msg.sender;
    require couplingInv();
    require beforeIndex <= a.transactionCount;
    
    a.clearOldTransactions(eA, beforeIndex);
    ao.clearOldTransactions(eAo, beforeIndex);
    

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfResetUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.resetUserRewards(address).selector,
    g -> g.selector == sig:ao.resetUserRewards(address).selector
} {
    env eA;
    env eAo;
    address user;
    
    require eA.msg.sender == eAo.msg.sender;
    require couplingInv();
    
    a.resetUserRewards(eA, user);
    ao.resetUserRewards(eAo, user);
    
    assert a.rewardPoints[user] == 0;
    assert ao.rewardPoints[user] == 0;
    
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfGetUserData(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserData(address).selector,
    g -> g.selector == sig:ao.getUserData(address).selector
} {
    env eA;
    env eAo;
    address user;
    
    require eA == eAo && couplingInv();
    
    uint256 balanceA; bool registeredA; uint256 lastActivityA; uint256 rewardsA;
    uint256 balanceAo; bool registeredAo; uint256 lastActivityAo; uint256 rewardsAo;
    
    balanceA, registeredA, lastActivityA, rewardsA = a.getUserData(eA, user);
    balanceAo, registeredAo, lastActivityAo, rewardsAo = ao.getUserData(eAo, user);
    
    assert balanceA == balanceAo;
    assert registeredA == registeredAo;
    assert lastActivityA == lastActivityAo;
    assert rewardsA == rewardsAo;

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfCleanupInactiveUsers(method f, method g)
filtered {
    f -> f.selector == sig:a.cleanupInactiveUsers(address[],uint256).selector,
    g -> g.selector == sig:ao.cleanupInactiveUsers(address[],uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

invariant deletedStorageEquivalence(address user)
    (!ao.isRegistered[user] => (
        ao.rewardPoints[user] == 0 &&
        (ao.lastActivityTime[user] == 0 || ao.lastActivityTime[user] > 0) 
    )) &&
    (!a.isRegistered[user] => (
        a.rewardPoints[user] == 0 &&
        (a.lastActivityTime[user] == 0 || a.lastActivityTime[user] > 0)
    ));
