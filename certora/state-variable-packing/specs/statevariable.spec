using A as a;
using Ao as ao;

methods {
    function a.quantity() external returns (uint128) envfree;
    function ao.quantity() external returns (uint128) envfree;
    function a.price() external returns (uint128) envfree;
    function ao.price() external returns (uint128) envfree;
    function a.total() external returns (uint256) envfree;
    function ao.total() external returns (uint256) envfree;
    function a.sumNarrow() external returns (uint256) envfree;
    function ao.sumNarrow() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.quantity() == ao.quantity() &&
    a.price() == ao.price() &&
    a.total() == ao.total();

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

rule gasOptimizedCorrectnessOfUpdate(method f, method g)
    filtered {
        f -> f.selector == sig:a.update(uint128, uint128).selector,
        g -> g.selector == sig:ao.update(uint128, uint128).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetTotal(method f, method g)
    filtered {
        f -> f.selector == sig:a.setTotal(uint256).selector,
        g -> g.selector == sig:ao.setTotal(uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule returnsOfSumNarrow() {
    require couplingInv();
    assert a.sumNarrow() == ao.sumNarrow();
}
