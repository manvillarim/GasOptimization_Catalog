using A as a;
using Ao as ao;

methods {
    function a.createUser(address, uint256, uint8) external returns (uint256);
    function ao.createUser(address, uint256, uint8) external returns (uint256);
    function a.updateUser(uint256, uint256, bool, uint8) external;
    function ao.updateUser(uint256, uint256, bool, uint8) external;
    function a.getUserData(uint256) external returns (uint256, bool, uint8, address) envfree;
    function ao.getUserData(uint256) external returns (uint256, bool, uint8, address) envfree;
    function a.deactivateUser(uint256) external;
    function ao.deactivateUser(uint256) external;
    function a.updateBalance(uint256, uint256) external;
    function ao.updateBalance(uint256, uint256) external;
    function a.updateTier(uint256, uint8) external;
    function ao.updateTier(uint256, uint8) external;
    function a.getTotalInfo(uint256) external returns (uint256) envfree;
    function ao.getTotalInfo(uint256) external returns (uint256) envfree;
    function a.userCount() external returns (uint256) envfree;
    function ao.userCount() external returns (uint256) envfree;
    function a.users(uint256) external returns (uint256, bool, uint8, address) envfree;
    function ao.users(uint256) external returns (address, uint8, bool, uint256) envfree;
}

definition basicCouplingInv() returns bool = a.userCount == ao.userCount;

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && basicCouplingInv();
    a.f(eA, args);
    ao.g(eAo, args);
    assert basicCouplingInv();
}

rule getUserDataEquivalence(uint256 userId) {
    require userId < a.userCount && userId < ao.userCount;
    require a.userCount == ao.userCount;
    uint256 balanceA;
    bool isActiveA;
    uint8 tierA;
    address walletA;
    uint256 balanceAo;
    bool isActiveAo;
    uint8 tierAo;
    address walletAo;
    balanceA, isActiveA, tierA, walletA = a.getUserData(userId);
    balanceAo, isActiveAo, tierAo, walletAo = ao.getUserData(userId);
    assert balanceA == balanceAo;
    assert isActiveA == isActiveAo;
    assert tierA == tierAo;
    assert walletA == walletAo;
}

rule getTotalInfoEquivalence(uint256 userId) {
    require userId < a.userCount && userId < ao.userCount;
    require a.userCount == ao.userCount;
    uint256 balanceA;
    bool isActiveA;
    uint8 tierA;
    address walletA;
    uint256 balanceAo;
    bool isActiveAo;
    uint8 tierAo;
    address walletAo;
    balanceA, isActiveA, tierA, walletA = a.getUserData(userId);
    balanceAo, isActiveAo, tierAo, walletAo = ao.getUserData(userId);
    require balanceA == balanceAo;
    require isActiveA == isActiveAo;
    require tierA == tierAo;
    require walletA == walletAo;
    uint256 totalA = a.getTotalInfo(userId);
    uint256 totalAo = ao.getTotalInfo(userId);
    assert totalA == totalAo;
}

rule gasOptimizedCorrectnessOfcreateUser(method f, method g)
filtered { f -> f.selector == sig:a.createUser(address, uint256, uint8).selector, g -> g.selector == sig:ao.createUser(address, uint256, uint8).selector } {
    env eA;
    env eAo;
    address wallet;
    uint256 initialBalance;
    uint8 tier;
    require eA == eAo && basicCouplingInv();
    uint256 userIdA = a.createUser(eA, wallet, initialBalance, tier);
    uint256 userIdAo = ao.createUser(eAo, wallet, initialBalance, tier);
    assert userIdA == userIdAo;
    assert basicCouplingInv();
    uint256 balanceA;
    bool isActiveA;
    uint8 tierRetA;
    address walletRetA;
    uint256 balanceAo;
    bool isActiveAo;
    uint8 tierRetAo;
    address walletRetAo;
    balanceA, isActiveA, tierRetA, walletRetA = a.getUserData(userIdA);
    balanceAo, isActiveAo, tierRetAo, walletRetAo = ao.getUserData(userIdAo);
    assert balanceA == balanceAo;
    assert isActiveA == isActiveAo;
    assert tierRetA == tierRetAo;
    assert walletRetA == walletRetAo;
}

rule gasOptimizedCorrectnessOfupdateUser(method f, method g)
filtered { f -> f.selector == sig:a.updateUser(uint256, uint256, bool, uint8).selector, g -> g.selector == sig:ao.updateUser(uint256, uint256, bool, uint8).selector } {
    env eA;
    env eAo;
    uint256 userId;
    uint256 newBalance;
    bool isActive;
    uint8 tier;
    require eA == eAo && basicCouplingInv();
    require userId < a.userCount;
    uint256 balanceBeforeA;
    bool isActiveBeforeA;
    uint8 tierBeforeA;
    address walletBeforeA;
    uint256 balanceBeforeAo;
    bool isActiveBeforeAo;
    uint8 tierBeforeAo;
    address walletBeforeAo;
    balanceBeforeA, isActiveBeforeA, tierBeforeA, walletBeforeA = a.getUserData(userId);
    balanceBeforeAo, isActiveBeforeAo, tierBeforeAo, walletBeforeAo = ao.getUserData(userId);
    require balanceBeforeA == balanceBeforeAo;
    require isActiveBeforeA == isActiveBeforeAo;
    require tierBeforeA == tierBeforeAo;
    require walletBeforeA == walletBeforeAo;
    a.updateUser(eA, userId, newBalance, isActive, tier);
    ao.updateUser(eAo, userId, newBalance, isActive, tier);
    assert basicCouplingInv();
    uint256 balanceA;
    bool isActiveRetA;
    uint8 tierRetA;
    address walletA;
    uint256 balanceAo;
    bool isActiveRetAo;
    uint8 tierRetAo;
    address walletAo;
    balanceA, isActiveRetA, tierRetA, walletA = a.getUserData(userId);
    balanceAo, isActiveRetAo, tierRetAo, walletAo = ao.getUserData(userId);
    assert balanceA == balanceAo;
    assert isActiveRetA == isActiveRetAo;
    assert tierRetA == tierRetAo;
    assert walletA == walletAo;
}

rule gasOptimizedCorrectnessOfdeactivateUser(method f, method g)
filtered { f -> f.selector == sig:a.deactivateUser(uint256).selector, g -> g.selector == sig:ao.deactivateUser(uint256).selector } {
    env eA;
    env eAo;
    uint256 userId;
    require eA == eAo && basicCouplingInv();
    require userId < a.userCount;
    uint256 balanceBeforeA;
    bool isActiveBeforeA;
    uint8 tierBeforeA;
    address walletBeforeA;
    uint256 balanceBeforeAo;
    bool isActiveBeforeAo;
    uint8 tierBeforeAo;
    address walletBeforeAo;
    balanceBeforeA, isActiveBeforeA, tierBeforeA, walletBeforeA = a.getUserData(userId);
    balanceBeforeAo, isActiveBeforeAo, tierBeforeAo, walletBeforeAo = ao.getUserData(userId);
    require balanceBeforeA == balanceBeforeAo;
    require isActiveBeforeA == isActiveBeforeAo;
    require tierBeforeA == tierBeforeAo;
    require walletBeforeA == walletBeforeAo;
    a.deactivateUser(eA, userId);
    ao.deactivateUser(eAo, userId);
    assert basicCouplingInv();
    uint256 balanceA;
    bool isActiveA;
    uint8 tierA;
    address walletA;
    uint256 balanceAo;
    bool isActiveAo;
    uint8 tierAo;
    address walletAo;
    balanceA, isActiveA, tierA, walletA = a.getUserData(userId);
    balanceAo, isActiveAo, tierAo, walletAo = ao.getUserData(userId);
    assert isActiveA == false;
    assert isActiveAo == false;
    assert balanceA == balanceAo;
    assert tierA == tierAo;
    assert walletA == walletAo;
}

rule gasOptimizedCorrectnessOfupdateBalance(method f, method g)
filtered { f -> f.selector == sig:a.updateBalance(uint256, uint256).selector, g -> g.selector == sig:ao.updateBalance(uint256, uint256).selector } {
    env eA;
    env eAo;
    uint256 userId;
    uint256 newBalance;
    require eA == eAo && basicCouplingInv();
    require userId < a.userCount;
    uint256 balanceBeforeA;
    bool isActiveBeforeA;
    uint8 tierBeforeA;
    address walletBeforeA;
    uint256 balanceBeforeAo;
    bool isActiveBeforeAo;
    uint8 tierBeforeAo;
    address walletBeforeAo;
    balanceBeforeA, isActiveBeforeA, tierBeforeA, walletBeforeA = a.getUserData(userId);
    balanceBeforeAo, isActiveBeforeAo, tierBeforeAo, walletBeforeAo = ao.getUserData(userId);
    require balanceBeforeA == balanceBeforeAo;
    require isActiveBeforeA == isActiveBeforeAo;
    require tierBeforeA == tierBeforeAo;
    require walletBeforeA == walletBeforeAo;
    a.updateBalance(eA, userId, newBalance);
    ao.updateBalance(eAo, userId, newBalance);
    assert basicCouplingInv();
    uint256 balanceA;
    bool isActiveA;
    uint8 tierA;
    address walletA;
    uint256 balanceAo;
    bool isActiveAo;
    uint8 tierAo;
    address walletAo;
    balanceA, isActiveA, tierA, walletA = a.getUserData(userId);
    balanceAo, isActiveAo, tierAo, walletAo = ao.getUserData(userId);
    assert balanceA == newBalance;
    assert balanceAo == newBalance;
    assert isActiveA == isActiveAo;
    assert tierA == tierAo;
    assert walletA == walletAo;
}

rule gasOptimizedCorrectnessOfupdateTier(method f, method g)
filtered { f -> f.selector == sig:a.updateTier(uint256, uint8).selector, g -> g.selector == sig:ao.updateTier(uint256, uint8).selector } {
    env eA;
    env eAo;
    uint256 userId;
    uint8 newTier;
    require eA == eAo && basicCouplingInv();
    require userId < a.userCount;
    uint256 balanceBeforeA;
    bool isActiveBeforeA;
    uint8 tierBeforeA;
    address walletBeforeA;
    uint256 balanceBeforeAo;
    bool isActiveBeforeAo;
    uint8 tierBeforeAo;
    address walletBeforeAo;
    balanceBeforeA, isActiveBeforeA, tierBeforeA, walletBeforeA = a.getUserData(userId);
    balanceBeforeAo, isActiveBeforeAo, tierBeforeAo, walletBeforeAo = ao.getUserData(userId);
    require balanceBeforeA == balanceBeforeAo;
    require isActiveBeforeA == isActiveBeforeAo;
    require tierBeforeA == tierBeforeAo;
    require walletBeforeA == walletBeforeAo;
    a.updateTier(eA, userId, newTier);
    ao.updateTier(eAo, userId, newTier);
    assert basicCouplingInv();
    uint256 balanceA;
    bool isActiveA;
    uint8 tierA;
    address walletA;
    uint256 balanceAo;
    bool isActiveAo;
    uint8 tierAo;
    address walletAo;
    balanceA, isActiveA, tierA, walletA = a.getUserData(userId);
    balanceAo, isActiveAo, tierAo, walletAo = ao.getUserData(userId);
    assert tierA == newTier;
    assert tierAo == newTier;
    assert balanceA == balanceAo;
    assert isActiveA == isActiveAo;
    assert walletA == walletAo;
}

