using A as a;
using Ao as ao;

methods {
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
    function a.balanceOf(address) external returns (uint256) envfree;
    function ao.balanceOf(address) external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.owner() == ao.owner() &&
    (forall address u. a.balances[u] == ao.balances[u]) &&
    (forall address u. a.isAuthorized[u] == ao.isAuthorized[u]);

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

rule gasOptimizedCorrectnessOfAuthorize(method f, method g)
    filtered {
        f -> f.selector == sig:a.authorize(address).selector,
        g -> g.selector == sig:ao.authorize(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetBalance(method f, method g)
    filtered {
        f -> f.selector == sig:a.setBalance(address, uint256).selector,
        g -> g.selector == sig:ao.setBalance(address, uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCredit(method f, method g)
    filtered {
        f -> f.selector == sig:a.credit(address, uint256).selector,
        g -> g.selector == sig:ao.credit(address, uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule returnsOfBalanceOf(address user) {
    require couplingInv();
    assert a.balanceOf(user) == ao.balanceOf(user);
}
