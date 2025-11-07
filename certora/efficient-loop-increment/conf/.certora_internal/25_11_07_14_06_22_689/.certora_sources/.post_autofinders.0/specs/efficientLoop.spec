using A as a;
using Ao as ao;

methods {
    function a.getData() external returns (uint256) envfree;
    function ao.getData() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.getData() == ao.getData();

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

rule gasOptimizedCorrectnessOfLoop(method f, method g)
    filtered {
        f -> f.selector == sig:a.loop(uint256).selector,
        g -> g.selector == sig:ao.loop(uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}
