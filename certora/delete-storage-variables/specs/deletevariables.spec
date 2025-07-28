using A as a;
using Ao as ao;



// Define coupling invariant to check equivalence between contracts
definition couplingInv() returns bool =
    a.totalUsers == ao.totalUsers &&
    a.totalBalance == ao.totalBalance &&
    a.rewardPool == ao.rewardPool &&
    a.transactionCount == ao.transactionCount &&
    // Check all users array equivalence
    (forall uint256 i. (i < a.totalUsers => a.allUsers[i] == ao.allUsers[i])) &&
    // Check all user mappings for registered users
    (forall address user. (
        a.isRegistered[user] == ao.isRegistered[user] &&
        (a.isRegistered[user] => (
            a.balances[user] == ao.balances[user] &&
            a.lastActivityTime[user] == ao.lastActivityTime[user] &&
            a.rewardPoints[user] == ao.rewardPoints[user] &&
            a.userIndex[user] == ao.userIndex[user]
        ))
    ));

// Define state equivalence for removed users (should have zero/default values)
definition removedUserStateEquivalent(address user) returns bool =
    (!a.isRegistered[user] && !ao.isRegistered[user]) &&
    (a.balances[user] == 0 && ao.balances[user] == 0) &&
    (a.rewardPoints[user] == 0 && ao.rewardPoints[user] == 0);

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
}

// Invariant: deleted storage in Ao should be equivalent to zero values in A
invariant deletedStorageEquivalence(address user)
    !ao.isRegistered[user] => (
        ao.balances[user] == 0 &&
        ao.rewardPoints[user] == 0 &&
        ao.lastActivityTime[user] == 0
    );

// Invariant: total users count should match actual registered users
invariant totalUsersConsistency()
    a.totalUsers == ao.totalUsers &&
    (forall uint256 i. i < a.totalUsers => (
        a.isRegistered[a.allUsers[i]] && ao.isRegistered[ao.allUsers[i]]
    ));