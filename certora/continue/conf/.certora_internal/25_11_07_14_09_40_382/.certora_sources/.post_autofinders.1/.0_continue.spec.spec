using A as a;
using Ao as ao;

methods {
    // Contract A methods
    function a.registerUser() external;
    function a.addBalance(uint256) external;
    function a.distributeRewards(uint256) external;
    function a.processMultipleUsers(address[], uint256) external;
    function a.deactivateUser(address) external;
    function a.getUserData(address) external returns (uint256, uint256, bool);
    
    function a.users(address) external returns (uint256, uint256, bool) envfree;
    function a.userList(uint256) external returns (address) envfree;
    function a.totalRewards() external returns (uint256) envfree;
    function a.activeUserCount() external returns (uint256) envfree;
    function a.getUserListLength() external returns (uint256) envfree;
    
    // Contract Ao methods
    function ao.registerUser() external;
    function ao.addBalance(uint256) external;
    function ao.distributeRewards(uint256) external;
    function ao.processMultipleUsers(address[], uint256) external;
    function ao.deactivateUser(address) external;
    function ao.getUserData(address) external returns (uint256, uint256, bool);
    
    function ao.users(address) external returns (uint256, uint256, bool) envfree;
    function ao.userList(uint256) external returns (address) envfree;
    function ao.totalRewards() external returns (uint256) envfree;
    function ao.activeUserCount() external returns (uint256) envfree;
    function ao.getUserListLength() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.totalRewards() == ao.totalRewards() &&
    a.activeUserCount() == ao.activeUserCount() &&
    a.getUserListLength() == ao.getUserListLength() &&
    (forall uint256 i. (i < a.userList.length => 
        a.userList[i] == ao.userList[i]
    )) &&
    (forall address user. (
        a.users[user].balance == ao.users[user].balance &&
        a.users[user].rewards == ao.users[user].rewards &&
        a.users[user].isActive == ao.users[user].isActive
    ));

// Generic correctness function for all method pairs
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();

    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;

    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}
// Rule for registerUser
rule gasOptimizedCorrectnessOf_registerUser(method f, method g)
filtered {
    f -> f.selector == sig:a.registerUser().selector,
    g -> g.selector == sig:ao.registerUser().selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for addBalance
rule gasOptimizedCorrectnessOf_addBalance(method f, method g)
filtered {
    f -> f.selector == sig:a.addBalance(uint256).selector,
    g -> g.selector == sig:ao.addBalance(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for distributeRewards (main optimization target)
rule gasOptimizedCorrectnessOf_distributeRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.distributeRewards(uint256).selector,
    g -> g.selector == sig:ao.distributeRewards(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for processMultipleUsers (main optimization target)
rule gasOptimizedCorrectnessOf_processMultipleUsers(method f, method g)
filtered {
    f -> f.selector == sig:a.processMultipleUsers(address[],uint256).selector,
    g -> g.selector == sig:ao.processMultipleUsers(address[],uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for deactivateUser
rule gasOptimizedCorrectnessOf_deactivateUser(method f, method g)
filtered {
    f -> f.selector == sig:a.deactivateUser(address).selector,
    g -> g.selector == sig:ao.deactivateUser(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for getUserData
rule gasOptimizedCorrectnessOf_getUserData(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserData(address).selector,
    g -> g.selector == sig:ao.getUserData(address).selector
} {
    gasOptimizationCorrectness(f, g);
}
