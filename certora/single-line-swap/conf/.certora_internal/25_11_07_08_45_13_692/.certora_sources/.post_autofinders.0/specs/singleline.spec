using A as a;
using Ao as ao;

methods {

}

definition couplingInv() returns bool =
    a.valueA == ao.valueA &&
    a.valueB == ao.valueB;

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

rule gasOptimizedCorrectnessOfSwapValues(method f, method g)
filtered {
    f -> f.selector == sig:a.swapValues().selector,
    g -> g.selector == sig:ao.swapValues().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSwapArrayElements(method f, method g)
filtered {
    f -> f.selector == sig:a.swapArrayElements(uint[], uint, uint).selector,
    g -> g.selector == sig:ao.swapArrayElements(uint[], uint, uint).selector
} {
    gasOptimizationCorrectness(f, g);
}