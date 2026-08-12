using A as a;
using Ao as ao;

methods {
    function a.counter() external returns (uint256) envfree;
    function ao.counter() external returns (uint256) envfree;
    function a.flag() external returns (bool) envfree;
    function ao.flag() external returns (bool) envfree;
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
}

definition couplingInv() returns bool =
    a.counter() == ao.counter() &&
    a.flag() == ao.flag() &&
    a.owner() == ao.owner();

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

rule gasOptimizedCorrectnessOfSetOwner(method f, method g)
    filtered {
        f -> f.selector == sig:a.setOwner(address).selector,
        g -> g.selector == sig:ao.setOwner(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBump(method f, method g)
    filtered {
        f -> f.selector == sig:a.bump().selector,
        g -> g.selector == sig:ao.bump().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfProcessArray(method f, method g)
    filtered {
        f -> f.selector == sig:a.processArray(uint256[]).selector,
        g -> g.selector == sig:ao.processArray(uint256[]).selector
    } {
    gasOptimizationCorrectness(f, g);
}
