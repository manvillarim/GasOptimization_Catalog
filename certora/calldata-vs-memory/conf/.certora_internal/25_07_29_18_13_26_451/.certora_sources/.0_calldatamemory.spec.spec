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

// Ghost variables to track user data
ghost mapping(uint256 => uint256) ghostUserId_A;
ghost mapping(uint256 => uint256) ghostUserBalance_A;
ghost mapping(uint256 => uint256) ghostUserLastActivity_A;
ghost mapping(uint256 => bool) ghostUserIsActive_A;

ghost mapping(uint256 => uint256) ghostUserId_Ao;
ghost mapping(uint256 => uint256) ghostUserBalance_Ao;
ghost mapping(uint256 => uint256) ghostUserLastActivity_Ao;
ghost mapping(uint256 => bool) ghostUserIsActive_Ao;

// Ghost variables to track transaction data
ghost mapping(uint256 => address) ghostTxnFrom_A;
ghost mapping(uint256 => address) ghostTxnTo_A;
ghost mapping(uint256 => uint256) ghostTxnAmount_A;
ghost mapping(uint256 => uint256) ghostTxnTimestamp_A;

ghost mapping(uint256 => address) ghostTxnFrom_Ao;
ghost mapping(uint256 => address) ghostTxnTo_Ao;
ghost mapping(uint256 => uint256) ghostTxnAmount_Ao;
ghost mapping(uint256 => uint256) ghostTxnTimestamp_Ao;

// P(A, Ao) - Complete coupling invariant using ghost variables
definition couplingInv() returns bool =
    // Relação 3: Equivalência de variáveis de estado
    a.totalUsers == ao.totalUsers &&
    a.totalTransactions == ao.totalTransactions &&
    a.totalBalance == ao.totalBalance &&
    
    // Relação 1: Equivalência de estado para users
    (forall uint256 id. (
        ghostUserId_A[id] == ghostUserId_Ao[id] &&
        ghostUserBalance_A[id] == ghostUserBalance_Ao[id] &&
        ghostUserLastActivity_A[id] == ghostUserLastActivity_Ao[id] &&
        ghostUserIsActive_A[id] == ghostUserIsActive_Ao[id]
    )) &&
    
    // Relação 2: Equivalência de estado para transactions
    (forall uint256 id. (
        ghostTxnFrom_A[id] == ghostTxnFrom_Ao[id] &&
        ghostTxnTo_A[id] == ghostTxnTo_Ao[id] &&
        ghostTxnAmount_A[id] == ghostTxnAmount_Ao[id] &&
        ghostTxnTimestamp_A[id] == ghostTxnTimestamp_Ao[id]
    ));

// Hook to sync ghost variables with actual user data for contract A
hook Sload (uint256 id, uint256 balance, uint256 lastActivity, bool isActive) a.users[KEY uint256 userId] {
    require ghostUserId_A[userId] == id;
    require ghostUserBalance_A[userId] == balance;
    require ghostUserLastActivity_A[userId] == lastActivity;
    require ghostUserIsActive_A[userId] == isActive;
}

hook Sstore a.users[KEY uint256 userId].(uint256 id, uint256 balance, uint256 lastActivity, bool isActive) {
    ghostUserId_A[userId] = id;
    ghostUserBalance_A[userId] = balance;
    ghostUserLastActivity_A[userId] = lastActivity;
    ghostUserIsActive_A[userId] = isActive;
}

// Hook to sync ghost variables with actual user data for contract Ao
hook Sload (uint256 id, uint256 balance, uint256 lastActivity, bool isActive) ao.users[KEY uint256 userId] {
    require ghostUserId_Ao[userId] == id;
    require ghostUserBalance_Ao[userId] == balance;
    require ghostUserLastActivity_Ao[userId] == lastActivity;
    require ghostUserIsActive_Ao[userId] == isActive;
}

hook Sstore ao.users[KEY uint256 userId].(uint256 id, uint256 balance, uint256 lastActivity, bool isActive) {
    ghostUserId_Ao[userId] = id;
    ghostUserBalance_Ao[userId] = balance;
    ghostUserLastActivity_Ao[userId] = lastActivity;
    ghostUserIsActive_Ao[userId] = isActive;
}

// Hook to sync ghost variables with transaction data for contract A
hook Sload (address from, address to, uint256 amount, uint256 timestamp) a.transactions[KEY uint256 txnId] {
    require ghostTxnFrom_A[txnId] == from;
    require ghostTxnTo_A[txnId] == to;
    require ghostTxnAmount_A[txnId] == amount;
    require ghostTxnTimestamp_A[txnId] == timestamp;
}

hook Sstore a.transactions[KEY uint256 txnId].(address from, address to, uint256 amount, uint256 timestamp) {
    ghostTxnFrom_A[txnId] = from;
    ghostTxnTo_A[txnId] = to;
    ghostTxnAmount_A[txnId] = amount;
    ghostTxnTimestamp_A[txnId] = timestamp;
}

// Hook to sync ghost variables with transaction data for contract Ao
hook Sload (address from, address to, uint256 amount, uint256 timestamp) ao.transactions[KEY uint256 txnId] {
    require ghostTxnFrom_Ao[txnId] == from;
    require ghostTxnTo_Ao[txnId] == to;
    require ghostTxnAmount_Ao[txnId] == amount;
    require ghostTxnTimestamp_Ao[txnId] == timestamp;
}

hook Sstore ao.transactions[KEY uint256 txnId].(address from, address to, uint256 amount, uint256 timestamp) {
    ghostTxnFrom_Ao[txnId] = from;
    ghostTxnTo_Ao[txnId] = to;
    ghostTxnAmount_Ao[txnId] = amount;
    ghostTxnTimestamp_Ao[txnId] = timestamp;
}

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

// Special rules for functions with return values

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

// Invariant: State consistency
invariant stateConsistency()
    a.totalUsers == ao.totalUsers &&
    a.totalTransactions == ao.totalTransactions &&
    a.totalBalance == ao.totalBalance;

// Invariant: Users data synchronized with ghosts
invariant userGhostSync(uint256 id) {
    uint256 idA; uint256 balanceA; uint256 lastActivityA; bool isActiveA;
    uint256 idAo; uint256 balanceAo; uint256 lastActivityAo; bool isActiveAo;
    
    idA, balanceA, lastActivityA, isActiveA = a.users(id);
    idAo, balanceAo, lastActivityAo, isActiveAo = ao.users(id);
    
    return ghostUserId_A[id] == idA &&
           ghostUserBalance_A[id] == balanceA &&
           ghostUserLastActivity_A[id] == lastActivityA &&
           ghostUserIsActive_A[id] == isActiveA &&
           ghostUserId_Ao[id] == idAo &&
           ghostUserBalance_Ao[id] == balanceAo &&
           ghostUserLastActivity_Ao[id] == lastActivityAo &&
           ghostUserIsActive_Ao[id] == isActiveAo;
}

// Invariant: Transaction data synchronized with ghosts  
invariant transactionGhostSync(uint256 id) {
    address fromA; address toA; uint256 amountA; uint256 timestampA;
    address fromAo; address toAo; uint256 amountAo; uint256 timestampAo;
    
    fromA, toA, amountA, timestampA = a.transactions(id);
    fromAo, toAo, amountAo, timestampAo = ao.transactions(id);
    
    return ghostTxnFrom_A[id] == fromA &&
           ghostTxnTo_A[id] == toA &&
           ghostTxnAmount_A[id] == amountA &&
           ghostTxnTimestamp_A[id] == timestampA &&
           ghostTxnFrom_Ao[id] == fromAo &&
           ghostTxnTo_Ao[id] == toAo &&
           ghostTxnAmount_Ao[id] == amountAo &&
           ghostTxnTimestamp_Ao[id] == timestampAo;
}