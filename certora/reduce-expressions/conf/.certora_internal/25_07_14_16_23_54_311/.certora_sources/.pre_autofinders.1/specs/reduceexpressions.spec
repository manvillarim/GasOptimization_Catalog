using A as a;
using Ao as ao;

methods {
    function a.calculateResult(bool, bool) external;
    function ao.calculateResult(bool, bool) external;
    function a.processValues(uint, uint, uint) external;
    function ao.processValues(uint, uint, uint) external;
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
    f -> f.selector == sig:calculateResult(bool, bool).selector,
    g -> g.selector == sig:calculateResult(bool, bool).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfProcessValues(method f, method g)
filtered {
    f -> f.selector == sig:processValues(uint, uint, uint).selector,
    g -> g.selector == sig:processValues(uint, uint, uint).selector
} {
    gasOptimizationCorrectness(f, g);
}