using A as a;
using Ao as ao;

methods {
    function setPermissions(bool, bool, bool, bool, bool, bool) external;
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

