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

    a.f(eA, args);
    ao.g(eAo, args);

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