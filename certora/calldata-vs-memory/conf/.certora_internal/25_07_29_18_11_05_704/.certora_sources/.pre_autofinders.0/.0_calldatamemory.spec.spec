using A as a;
using Ao as ao;

methods {
    // Contract A methods
    function a.users(uint256) external returns (uint256, uint256, uint256, bool) envfree;
    function a.transactions(uint256) external returns (address, address, uint256, uint256) envfree;
    function a.totalUsers() external returns (uint256) envfree;
    function a.totalTransactions() external returns (uint256) envfree;
    function a.totalBalance() external returns (uint256) envfree;
    
    // Contract Ao methods  
    function ao.users(uint256) external returns (uint256, uint256, uint256, bool) envfree;
    function ao.transactions(uint256) external returns (address, address, uint256, uint256) envfree;
    function ao.totalUsers() external returns (uint256) envfree;
    function ao.totalTransactions() external returns (uint256) envfree;
    function ao.totalBalance() external returns (uint256) envfree;
}

// Helper function to compare users
function usersEqual(uint256 id) returns bool {
    uint256 idA; uint256 balanceA; uint256 lastActivityA; bool isActiveA;
    uint256 idAo; uint256 balanceAo; uint256 lastActivityAo; bool isActiveAo;
    
    idA, balanceA, lastActivityA, isActiveA = a.users(id);
    idAo, balanceAo, lastActivityAo, isActiveAo = ao.users(id);
    
    return idA == idAo && balanceA == balanceAo && 
           lastActivityA == lastActivityAo && isActiveA == isActiveAo;
}

// Helper function to compare transactions
function transactionsEqual(uint256 id) returns bool {
    address fromA; address toA; uint256 amountA; uint256 timestampA;
    address fromAo; address toAo; uint256 amountAo; uint256 timestampAo;
    
    fromA, toA, amountA, timestampA = a.transactions(id);
    fromAo, toAo, amountAo, timestampAo = ao.transactions(id);
    
    return fromA == fromAo && toA == toAo && 
           amountA == amountAo && timestampA == timestampAo;
}

// P(A, Ao) - Complete coupling invariant
definition couplingInv() returns bool =

    a.totalUsers == ao.totalUsers &&
    a.totalTransactions == ao.totalTransactions &&
    a.totalBalance == ao.totalBalance &&
    
    (forall uint256 id. (usersEqual(id) && transactionsEqual(id)));

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

// Rule for processUser equivalence
rule gasOptimizedCorrectnessOfProcessUser(method f, method g)
filtered {
    f -> f.selector == sig:a.processUser(A.User).selector,
    g -> g.selector == sig:ao.processUser(Ao.User).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for batchProcessUsers equivalence
rule gasOptimizedCorrectnessOfBatchProcessUsers(method f, method g)
filtered {
    f -> f.selector == sig:a.batchProcessUsers(A.User[]).selector,
    g -> g.selector == sig:ao.batchProcessUsers(Ao.User[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for processTransaction equivalence
rule gasOptimizedCorrectnessOfProcessTransaction(method f, method g)
filtered {
    f -> f.selector == sig:a.processTransaction(A.Transaction).selector,
    g -> g.selector == sig:ao.processTransaction(Ao.Transaction).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for batchProcessTransactions equivalence
rule gasOptimizedCorrectnessOfBatchProcessTransactions(method f, method g)
filtered {
    f -> f.selector == sig:a.batchProcessTransactions(A.Transaction[]).selector,
    g -> g.selector == sig:ao.batchProcessTransactions(Ao.Transaction[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Special rules for functions with return values that need verification

// Rule for processNumbers - verify return values
rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g)
filtered {
    f -> f.selector == sig:a.processNumbers(uint256[]).selector,
    g -> g.selector == sig:ao.processNumbers(uint256[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
    uint256 sumA; uint256 averageA;
    uint256 sumAo; uint256 averageAo;
    
    sumA, averageA = a.processNumbers(eA, args);
    sumAo, averageAo = ao.processNumbers(eAo, args);
    
    // Verify outputs are identical
    assert sumA == sumAo;
    assert averageA == averageAo;
}

// Rule for analyzeData - verify complex return values
rule gasOptimizedCorrectnessOfAnalyzeData(method f, method g)
filtered {
    f -> f.selector == sig:a.analyzeData(uint256[],A.User[],A.Transaction[]).selector,
    g -> g.selector == sig:ao.analyzeData(uint256[],Ao.User[],Ao.Transaction[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    uint256 sumValuesA; uint256 activeUsersA; uint256 totalTxnAmountA;
    uint256 sumValuesAo; uint256 activeUsersAo; uint256 totalTxnAmountAo;
    
    sumValuesA, activeUsersA, totalTxnAmountA = a.analyzeData(eA, args);
    sumValuesAo, activeUsersAo, totalTxnAmountAo = ao.analyzeData(eAo, args);
    
    // Verify all outputs are identical
    assert sumValuesA == sumValuesAo;
    assert activeUsersA == activeUsersAo;
    assert totalTxnAmountA == totalTxnAmountAo;
}

// Invariants

// Invariant: State consistency after operations
invariant stateConsistency()
    a.totalUsers == ao.totalUsers &&
    a.totalTransactions == ao.totalTransactions &&
    a.totalBalance == ao.totalBalance;

// Invariant: Users equivalence
invariant usersEquivalence(uint256 id)
    usersEqual(id);

// Invariant: Transactions equivalence  
invariant transactionsEquivalence(uint256 id)
    transactionsEqual(id);