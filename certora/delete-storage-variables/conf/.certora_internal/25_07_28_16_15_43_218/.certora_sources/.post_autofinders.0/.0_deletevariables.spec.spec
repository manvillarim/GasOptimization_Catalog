using A as a;
using Ao as ao;

methods {
    // Contract A methods
    function a.balances(address) external returns (uint256) envfree;
    function a.isRegistered(address) external returns (bool) envfree;
    function a.lastActivityTime(address) external returns (uint256) envfree;
    function a.rewardPoints(address) external returns (uint256) envfree;
    function a.allUsers(uint256) external returns (address) envfree;
    function a.userIndex(address) external returns (uint256) envfree;
    function a.totalUsers() external returns (uint256) envfree;
    function a.totalBalance() external returns (uint256) envfree;
    function a.rewardPool() external returns (uint256) envfree;
    function a.transactionCount() external returns (uint256) envfree;
    function a.transactionSenders(uint256) external returns (address) envfree;
    function a.transactionAmounts(uint256) external returns (uint256) envfree;
    function a.transactionTimestamps(uint256) external returns (uint256) envfree;
    
    // Contract Ao methods
    function ao.balances(address) external returns (uint256) envfree;
    function ao.isRegistered(address) external returns (bool) envfree;
    function ao.lastActivityTime(address) external returns (uint256) envfree;
    function ao.rewardPoints(address) external returns (uint256) envfree;
    function ao.allUsers(uint256) external returns (address) envfree;
    function ao.userIndex(address) external returns (uint256) envfree;
    function ao.totalUsers() external returns (uint256) envfree;
    function ao.totalBalance() external returns (uint256) envfree;
    function ao.rewardPool() external returns (uint256) envfree;
    function ao.transactionCount() external returns (uint256) envfree;
    function ao.transactionSenders(uint256) external returns (address) envfree;
    function ao.transactionAmounts(uint256) external returns (uint256) envfree;
    function ao.transactionTimestamps(uint256) external returns (uint256) envfree;
    function ao.oldestTransactionIndex() external returns (uint256) envfree;
}

// P(A, Ao) - Complete coupling invariant as specified
definition couplingInv() returns bool =
    // Relação 1: Equivalência dos dados de usuário
    (forall address addr. (
        a.balances[addr] == ao.balances[addr] &&
        a.isRegistered[addr] == ao.isRegistered[addr] &&
        a.lastActivityTime[addr] == ao.lastActivityTime[addr] &&
        a.rewardPoints[addr] == ao.rewardPoints[addr] &&
        a.userIndex[addr] == ao.userIndex[addr]
    )) &&
    // Relação 2: Equivalência do array de usuários
    (
        // Note: We use totalUsers as proxy for array length since CVL doesn't have direct array.length
        a.totalUsers == ao.totalUsers &&
        (forall uint256 i. (i < a.totalUsers => a.allUsers[i] == ao.allUsers[i]))
    ) &&
    // Relação 3: Equivalência das variáveis de estado globais
    (
        a.totalUsers == ao.totalUsers &&
        a.totalBalance == ao.totalBalance &&
        a.rewardPool == ao.rewardPool
    ) &&
    // Relação 4: Equivalência do histórico de transações
    (
        a.transactionCount == ao.transactionCount &&
        (forall uint256 i. (i < a.transactionCount => (
            a.transactionSenders[i] == ao.transactionSenders[i] &&
            a.transactionAmounts[i] == ao.transactionAmounts[i] &&
            a.transactionTimestamps[i] == ao.transactionTimestamps[i]
        )))
    ) &&
    // Relação 5: Condição sobre o índice de transações limpas
    (
        // oldestTransactionIndex in Ao should point to the first non-cleaned transaction
        (forall uint256 j. (j < ao.oldestTransactionIndex => (
            ao.transactionSenders[j] == 0 &&
            ao.transactionAmounts[j] == 0 &&
            ao.transactionTimestamps[j] == 0
        ))) &&
        (forall uint256 k. (k >= ao.oldestTransactionIndex && k < ao.transactionCount => (
            ao.transactionSenders[k] == a.transactionSenders[k] &&
            ao.transactionAmounts[k] == a.transactionAmounts[k] &&
            ao.transactionTimestamps[k] == a.transactionTimestamps[k]
        )))
    );

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
    
    // Verify coupling invariant holds
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
}

// Invariant: deleted storage in Ao should be equivalent to zero values
invariant deletedStorageEquivalence(address user)
    (!ao.isRegistered[user] => (
        ao.balances[user] == 0 &&
        ao.rewardPoints[user] == 0 &&
        ao.lastActivityTime[user] == 0
    )) &&
    (!a.isRegistered[user] => (
        a.balances[user] == 0 &&
        a.rewardPoints[user] == 0 &&
        a.lastActivityTime[user] == 0
    ));

// Invariant: total users count should match actual registered users
invariant totalUsersConsistency()
    a.totalUsers == ao.totalUsers &&
    (forall uint256 i. i < a.totalUsers => (
        a.isRegistered[a.allUsers[i]] && ao.isRegistered[ao.allUsers[i]]
    ));

// Invariant: transaction cleanup consistency
invariant transactionCleanupConsistency()
    // All transactions before oldestTransactionIndex in Ao should be cleaned (zero values)
    (forall uint256 i. i < ao.oldestTransactionIndex => (
        ao.transactionSenders[i] == 0 &&
        ao.transactionAmounts[i] == 0 &&
        ao.transactionTimestamps[i] == 0
    )) &&
    // All transactions at or after oldestTransactionIndex should match contract A
    (forall uint256 j. (j >= ao.oldestTransactionIndex && j < ao.transactionCount) => (
        ao.transactionSenders[j] == a.transactionSenders[j] &&
        ao.transactionAmounts[j] == a.transactionAmounts[j] &&
        ao.transactionTimestamps[j] == a.transactionTimestamps[j]
    ));