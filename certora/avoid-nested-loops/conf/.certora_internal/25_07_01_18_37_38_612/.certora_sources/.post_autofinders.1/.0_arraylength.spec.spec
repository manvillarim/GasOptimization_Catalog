
using A as a;
using Ao as ao;

methods {

    function a.getSum() external returns (uint256) envfree;
    function ao.getSum() external returns (uint256) envfree;
    function a.getLength() external returns (uint256) envfree;
    function ao.getLength() external returns (uint256) envfree;
    
}

definition couplingInv() returns bool = 
    a.getSum() == ao.getSum() && 
    a.getLength() == ao.getLength();

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
        f -> f.selector == sig:a.processNumbers().selector, 
        g -> g.selector == sig:ao.processNumbers().selector 
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfIncrementAll(method f, method g)
    filtered { 
        f -> f.selector == sig:a.incrementAll().selector, 
        g -> g.selector == sig:ao.incrementAll().selector 
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDoubleAndAdd(method f, method g)
    filtered { 
        f -> f.selector == sig:a.doubleAndAdd(uint256).selector, 
        g -> g.selector == sig:ao.doubleAndAdd(uint256).selector 
    } {
    gasOptimizationCorrectness(f, g);
}