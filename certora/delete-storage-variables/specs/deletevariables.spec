using A as a;
using Ao as ao;

methods {
    function a.balanceOf(address) external returns (uint256) envfree;
    function ao.balanceOf(address) external returns (uint256) envfree;
    function a.registeredOf(address) external returns (bool) envfree;
    function ao.registeredOf(address) external returns (bool) envfree;
}

definition couplingInv() returns bool =
    (forall address u. a.isRegistered[u] == ao.isRegistered[u]) &&
    (forall address u. a.isRegistered[u] => a.balances[u] == ao.balances[u]);

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

rule gasOptimizedCorrectnessOfRegister(method f, method g)
    filtered {
        f -> f.selector == sig:a.register().selector,
        g -> g.selector == sig:ao.register().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfRemoveUser(method f, method g)
    filtered {
        f -> f.selector == sig:a.removeUser(address).selector,
        g -> g.selector == sig:ao.removeUser(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule returnsOfBalanceOf(address user) {
    require couplingInv();
    assert a.balanceOf(user) == ao.balanceOf(user);
}

rule returnsOfRegisteredOf(address user) {
    require couplingInv();
    assert a.registeredOf(user) == ao.registeredOf(user);
}
