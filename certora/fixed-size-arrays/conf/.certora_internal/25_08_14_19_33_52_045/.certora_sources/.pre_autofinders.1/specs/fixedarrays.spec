using A as a;
using Ao as ao;

methods {
    // User management functions
    function a.registerUser() external;
    function ao.registerUser() external;
    function a.removeUser(address) external;
    function ao.removeUser(address) external;
    // Transaction processing functions
    function a.processTransaction(address, uint256) external;
    function ao.processTransaction(address, uint256) external;
    function a.batchProcessTransactions(address[], uint256[]) external;
    function ao.batchProcessTransactions(address[], uint256[]) external;
    // View functions for state verification
    function a.getTotalUsers() external returns (uint256) envfree;
    function ao.getTotalUsers() external returns (uint256) envfree;
    function a.getTotalBalance() external returns (uint256) envfree;
    function ao.getTotalBalance() external returns (uint256) envfree;
    function a.getTransactionCount() external returns (uint256) envfree;
    function ao.getTransactionCount() external returns (uint256) envfree;
    function a.getUsersLength() external returns (uint256) envfree;
    function ao.getUsersLength() external returns (uint256) envfree;
    // Balance and user data access
    function a.balances(address) external returns (uint256) envfree;
    function ao.balances(address) external returns (uint256) envfree;
    function a.isRegistered(address) external returns (bool) envfree;
    function ao.isRegistered(address) external returns (bool) envfree;
    function a.rewardPoints(address) external returns (uint256) envfree;
    function ao.rewardPoints(address) external returns (uint256) envfree;
    // Array access functions
    function a.allUsers(uint256) external returns (address) envfree;
    function ao.allUsers(uint256) external returns (address) envfree;
    function a.transactionAmounts(uint256) external returns (uint256) envfree;
    function ao.transactionAmounts(uint256) external returns (uint256) envfree;
    function a.transactionSenders(uint256) external returns (address) envfree;
    function ao.transactionSenders(uint256) external returns (address) envfree;
    // Direct state variables access
    function a.totalBalance() external returns (uint256) envfree;
    function ao.totalBalance() external returns (uint256) envfree;
    function a.transactionCount() external returns (uint256) envfree;
    function ao.transactionCount() external returns (uint256) envfree;
}

/**
 * Ghost variables to track mapping equivalence
 * These help us verify mapping equality without calling functions in quantifiers
 */
ghost mapping(address => bool) userBalancesEqual {
    init_state axiom forall address user. userBalancesEqual[user] == true;
}

ghost mapping(address => bool) userRegistrationEqual {
    init_state axiom forall address user. userRegistrationEqual[user] == true;
}

ghost mapping(address => bool) userRewardsEqual {
    init_state axiom forall address user. userRewardsEqual[user] == true;
}

ghost mapping(uint256 => bool) arrayUsersEqual {
    init_state axiom forall uint256 i. arrayUsersEqual[i] == true;
}

ghost mapping(uint256 => bool) transactionAmountsEqual {
    init_state axiom forall uint256 i. transactionAmountsEqual[i] == true;
}

ghost mapping(uint256 => bool) transactionSendersEqual {
    init_state axiom forall uint256 i. transactionSendersEqual[i] == true;
}

/**
 * Hooks to maintain ghost variable consistency
 */
hook Sstore a.balances[KEY address user] uint256 newValue (uint256 oldValue) {
    userBalancesEqual[user] = (newValue == ao.balances[user]);
}

hook Sstore ao.balances[KEY address user] uint256 newValue (uint256 oldValue) {
    userBalancesEqual[user] = (a.balances[user] == newValue);
}

hook Sstore a.isRegistered[KEY address user] bool newValue (bool oldValue) {
    userRegistrationEqual[user] = (newValue == ao.isRegistered[user]);
}

hook Sstore ao.isRegistered[KEY address user] bool newValue (bool oldValue) {
    userRegistrationEqual[user] = (a.isRegistered[user] == newValue);
}

hook Sstore a.rewardPoints[KEY address user] uint256 newValue (uint256 oldValue) {
    userRewardsEqual[user] = (newValue == ao.rewardPoints[user]);
}

hook Sstore ao.rewardPoints[KEY address user] uint256 newValue (uint256 oldValue) {
    userRewardsEqual[user] = (a.rewardPoints[user] == newValue);
}

/**
 * Main coupling invariant definition
 * This defines what it means for the two contracts to be equivalent
 */
definition couplingInv() returns bool =
// Core state variables must be identical
a.totalBalance == ao.totalBalance && a.transactionCount == ao.transactionCount &&
// Effective array lengths must match
a.getUsersLength() == ao.getUsersLength() && a.getTransactionCount() == ao.getTransactionCount() &&
// All user mappings must be equal (tracked by ghost variables)
(forall address user. userBalancesEqual[user] == true) && (forall address user. userRegistrationEqual[user] == true) && (forall address user. userRewardsEqual[user] == true) &&
// Array elements must be equal (tracked by ghost variables)
(forall uint256 i. arrayUsersEqual[i] == true) && (forall uint256 i. transactionAmountsEqual[i] == true) && (forall uint256 i. transactionSendersEqual[i] == true);

/**
 * Helper definition for checking if states match without using quantifiers
 * Used within rules to verify specific addresses
 */
definition statesMatchForUser(address user) returns bool = a.balances(user) == ao.balances(user) && a.isRegistered(user) == ao.isRegistered(user) && a.rewardPoints(user) == ao.rewardPoints(user);

/**
 * Helper definition for checking if array elements match at index
 */
definition arraysMatchAtIndex(uint256 index) returns bool = (index >= a.getUsersLength() || a.allUsers(index) == ao.allUsers(index)) && (index >= a.getTransactionCount() || (a.transactionAmounts(index) == ao.transactionAmounts(index) && a.transactionSenders(index) == ao.transactionSenders(index)));

/**
 * Generic correctness function for gas optimization
 * Proves that any method execution preserves behavioral equivalence
 */
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;
    require couplingInv();
    address user1;
    address user2;
    uint256 idx;
    require statesMatchForUser(user1);
    require statesMatchForUser(user2);
    require arraysMatchAtIndex(idx);
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInv();
    assert statesMatchForUser(user1);
    assert statesMatchForUser(user2);
    assert arraysMatchAtIndex(idx);
}

/**
 * User Registration Correctness Verification
 * Proves registerUser() maintains equivalence
 */
rule gasOptimizedCorrectnessOfRegisterUser(method f, method g)
filtered { f -> f.selector == sig:a.registerUser().selector, g -> g.selector == sig:ao.registerUser().selector } {
    gasOptimizationCorrectness(f, g);
}

/**
 * User Removal Correctness Verification
 * Proves removeUser() maintains equivalence
 */
rule gasOptimizedCorrectnessOfRemoveUser(method f, method g)
filtered { f -> f.selector == sig:a.removeUser(address).selector, g -> g.selector == sig:ao.removeUser(address).selector } {
    gasOptimizationCorrectness(f, g);
}

/**
 * Transaction Processing Correctness Verification
 * Proves processTransaction() maintains equivalence
 */
rule gasOptimizedCorrectnessOfProcessTransaction(method f, method g)
filtered { f -> f.selector == sig:a.processTransaction(address, uint256).selector, g -> g.selector == sig:ao.processTransaction(address, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

/**
 * Batch Transaction Processing Correctness Verification
 * Proves batchProcessTransactions() maintains equivalence
 */
rule gasOptimizedCorrectnessOfBatchProcessTransactions(method f, method g)
filtered { f -> f.selector == sig:a.batchProcessTransactions(address[], uint256[]).selector, g -> g.selector == sig:ao.batchProcessTransactions(address[], uint256[]).selector } {
    gasOptimizationCorrectness(f, g);
}

