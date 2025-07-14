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


rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g) 
    filtered {
        f -> f.selector == sig:a.calculateResults().selector,
        g -> g.selector == sig:ao.calculateResults().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g) 
    filtered {
        f -> f.selector == sig:a.processValues().selector,
        g -> g.selector == sig:ao.processValues().selector
    } {
    gasOptimizationCorrectness(f, g);
}

