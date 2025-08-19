using A as a;
using Ao as ao;

methods {

}


definition couplingInv() returns bool = a.r1 == ao.r1 && a.r2 == ao.r2;

function gasOptimizationCorrectness(method f, method g) { 
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}


rule gasOptimizedCorrectnessOfCalculateResult(method f, method g) 
    filtered {
        f -> f.selector == sig:a.calculateResult().selector,
        g -> g.selector == sig:ao.calculateResult().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfProcessValues(method f, method g) 
    filtered {
        f -> f.selector == sig:a.processValues().selector,
        g -> g.selector == sig:ao.processValues().selector
    } {
    gasOptimizationCorrectness(f, g);
}

