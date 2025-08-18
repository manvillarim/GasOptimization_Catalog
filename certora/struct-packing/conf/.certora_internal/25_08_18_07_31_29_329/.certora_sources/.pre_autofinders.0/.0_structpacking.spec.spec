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

definition couplingInv() returns bool = a.userCount == ao.userCount && (forall uint256 i. (i < a.userCount) => (getUserDataA(i).balance == getUserDataAo(i).balance && getUserDataA(i).isActive == getUserDataAo(i).isActive && getUserDataA(i).tier == getUserDataAo(i).tier && getUserDataA(i).wallet == getUserDataAo(i).wallet));

function getUserDataA(uint256 userId) returns (uint256, bool, uint8, address) {
    return a.getUserData(userId);
}

function getUserDataAo(uint256 userId) returns (uint256, bool, uint8, address) {
    return ao.getUserData(userId);
}

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && couplingInv();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfcreateUser(method f, method g)
filtered { f -> f.selector == sig:a.createUser(address, uint256, uint8).selector, g -> g.selector == sig:ao.createUser(address, uint256, uint8).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfupdateUser(method f, method g)
filtered { f -> f.selector == sig:a.updateUser(uint256, uint256, bool, uint8).selector, g -> g.selector == sig:ao.updateUser(uint256, uint256, bool, uint8).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfdeactivateUser(method f, method g)
filtered { f -> f.selector == sig:a.deactivateUser(uint256).selector, g -> g.selector == sig:ao.deactivateUser(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfupdateBalance(method f, method g)
filtered { f -> f.selector == sig:a.updateBalance(uint256, uint256).selector, g -> g.selector == sig:ao.updateBalance(uint256, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfupdateTier(method f, method g)
filtered { f -> f.selector == sig:a.updateTier(uint256, uint8).selector, g -> g.selector == sig:ao.updateTier(uint256, uint8).selector } {
    gasOptimizationCorrectness(f, g);
}

