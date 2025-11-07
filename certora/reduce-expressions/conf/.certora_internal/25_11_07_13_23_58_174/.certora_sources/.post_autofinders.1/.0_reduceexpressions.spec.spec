using A as a;
using Ao as ao;

methods {
}

definition couplingInv() returns bool = a.r2 == ao.r2;

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

rule gasOptimizedCorrectnessOfProcessValues(method f, method g)
filtered {
    f -> f.selector == sig:a.processValues(uint, uint, uint).selector,
    g -> g.selector == sig:ao.processValues(uint, uint, uint).selector
} {
    gasOptimizationCorrectness(f, g);
}