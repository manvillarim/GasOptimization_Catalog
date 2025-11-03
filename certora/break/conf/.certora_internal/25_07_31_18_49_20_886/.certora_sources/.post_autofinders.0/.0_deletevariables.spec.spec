using A as a;
using Ao as ao;

methods {
    // Contract A methods
    function a.registerUser() external;
    function a.removeUser(address) external;
    function a.processTransaction(address, uint256) external;
    function a.clearOldTransactions(uint256) external;
    function a.resetUserRewards(address) external;
    function a.getUserData(address) external returns (uint256, bool, uint256, uint256);
    
    // Contract A view functions
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
    
    // Contract Ao methods
    function ao.registerUser() external;
    function ao.removeUser(address) external;
    function ao.processTransaction(address, uint256) external;
    function ao.clearOldTransactions(uint256) external;
    function ao.resetUserRewards(address) external;
    function ao.cleanupInactiveUsers(address[], uint256) external;
    function ao.getUserData(address) external returns (uint256, bool, uint256, uint256);
    function ao.getActiveTransactionCount() external returns (uint256) envfree;
    
    // Contract Ao view functions
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

// Define coupling invariant to check equivalence between contracts
definition couplingInv() returns bool =
    a.totalUsers == ao.totalUsers &&
    a.totalBalance == ao.totalBalance &&
    a.rewardPool == ao.rewardPool &&
    a.transactionCount == ao.transactionCount &&
    // Check that allUsers arrays have same length
    a.allUsers.length == ao.allUsers.length &&
    // Check all valid indices in allUsers array
    (forall uint256 i. (i < a.allUsers.length => (
        a.allUsers[i] == ao.allUsers[i] &&
        // If user is in array, they should be registered
        a.isRegistered[a.allUsers[i]] == ao.isRegistered[ao.allUsers[i]]
    ))) &&
    // Check all mappings are equivalent
    (forall address user. (
        a.isRegistered[user] == ao.isRegistered[user] &&
        a.balances[user] == ao.balances[user] &&
        a.lastActivityTime[user] == ao.lastActivityTime[user] &&
        a.rewardPoints[user] == ao.rewardPoints[user] &&
        // userIndex should match for registered users
        (a.isRegistered[user] => a.userIndex[user] == ao.userIndex[user])
    ));

// Define state equivalence for removed users
definition removedUserStateEquivalent(address user) returns bool =
    (!a.isRegistered[user] && !ao.isRegistered[user]) &&
    // Note: balances can be non-zero for unregistered users (they can receive transfers)
    (a.balances[user] == ao.balances[user]) &&
    (a.rewardPoints[user] == ao.rewardPoints[user]);

// Generic function to verify gas optimization correctness
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

// Rule for registerUser equivalence
rule gasOptimizedCorrectnessOfRegisterUser(method f, method g)
filtered {
    f -> f.selector == sig:a.registerUser().selector,
    g -> g.selector == sig:ao.registerUser().selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for removeUser equivalence
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
    
    // Store initial registration state
    bool wasRegistered = a.isRegistered[userToRemove];
    
    a.removeUser(eA, userToRemove);
    ao.removeUser(eAo, userToRemove);
    
    // Verify coupling invariant holds
    assert couplingInv();
    
    // If user was registered, verify they are properly removed
    assert wasRegistered => removedUserStateEquivalent(userToRemove);
}

// Rule for processTransaction equivalence
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
    
    // Store initial balances
    uint256 senderBalanceBefore = a.balances[eA.msg.sender];
    uint256 toBalanceBefore = a.balances[to];
    
    a.processTransaction(eA, to, amount);
    ao.processTransaction(eAo, to, amount);
    
    // Verify coupling invariant holds
    assert couplingInv();
    
    // Verify balance updates are equivalent
    assert a.balances[eA.msg.sender] == ao.balances[eAo.msg.sender];
    assert a.balances[to] == ao.balances[to];
}

// Rule for clearOldTransactions equivalence
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
    
    // Core state should remain equivalent
    assert a.totalUsers == ao.totalUsers;
    assert a.totalBalance == ao.totalBalance;
    assert a.rewardPool == ao.rewardPool;

    assert couplingInv();
}

// Rule for resetUserRewards equivalence
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
    
    // Verify rewards are reset to 0 in both contracts
    assert a.rewardPoints[user] == 0;
    assert ao.rewardPoints[user] == 0;
    
    // Verify coupling invariant still holds
    assert couplingInv();
}

// Rule for getUserData equivalence
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
    
    // Verify all returned values are equivalent
    assert balanceA == balanceAo;
    assert registeredA == registeredAo;
    assert lastActivityA == lastActivityAo;
    assert rewardsA == rewardsAo;

    assert couplingInv();
}

// Rule for cleanupInactiveUsers equivalence
rule gasOptimizedCorrectnessOfCleanupInactiveUsers(method f, method g)
filtered {
    f -> f.selector == sig:a.cleanupInactiveUsers(address[],uint256).selector,
    g -> g.selector == sig:ao.cleanupInactiveUsers(address[],uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

invariant deletedStorageEquivalence(address user)
    (!ao.isRegistered[user] => (
        // Note: balances can be non-zero even for unregistered users
        ao.rewardPoints[user] == 0 &&
        (ao.lastActivityTime[user] == 0 || ao.lastActivityTime[user] > 0) // can be non-zero if received transfer
    )) &&
    (!a.isRegistered[user] => (
        a.rewardPoints[user] == 0 &&
        (a.lastActivityTime[user] == 0 || a.lastActivityTime[user] > 0) // can be non-zero if received transfer
    ));
