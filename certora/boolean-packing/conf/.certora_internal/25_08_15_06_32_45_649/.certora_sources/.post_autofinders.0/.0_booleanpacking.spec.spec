using A as a;
using Ao as ao;

methods {
    function a.setPermissions(bool, bool, bool, bool, bool, bool) external;
    function a.canMint() external returns (bool) envfree;
    function a.isPaused() external returns (bool) envfree;
    function a.isAdmin() external returns (bool) envfree;
    function a.isWhitelisted() external returns (bool) envfree;
    function a.transferEnabled() external returns (bool) envfree;
    function a.isFrozen() external returns (bool) envfree;
    function ao.setPermissions(bool, bool, bool, bool, bool, bool) external;
    function ao.canMint() external returns (bool) envfree;
    function ao.isPaused() external returns (bool) envfree;
    function ao.isAdmin() external returns (bool) envfree;
    function ao.isWhitelisted() external returns (bool) envfree;
    function ao.transferEnabled() external returns (bool) envfree;
    function ao.isFrozen() external returns (bool) envfree;
}

definition couplingInv() returns bool = a.canMint() == ao.canMint() && a.isPaused() == ao.isPaused() && a.isAdmin() == ao.isAdmin() && a.isWhitelisted() == ao.isWhitelisted() && a.transferEnabled() == ao.transferEnabled() && a.isFrozen() == ao.isFrozen();

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && couplingInv();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInv();
}

rule correctnessOfSetPermissions(method f, method g)
filtered { f -> f.selector == sig:a.setPermissions(bool, bool, bool, bool, bool, bool).selector, g -> g.selector == sig:ao.setPermissions(bool, bool, bool, bool, bool, bool).selector } {
    gasOptimizationCorrectness(f, g);
}

