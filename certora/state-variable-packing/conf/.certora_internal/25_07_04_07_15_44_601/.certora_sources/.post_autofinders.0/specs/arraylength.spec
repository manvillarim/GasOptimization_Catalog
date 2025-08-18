using A as a;
using Ao as ao;

methods {
    function a.getLength() external returns (uint256) envfree;
    function ao.getLength() external returns (uint256) envfree;
    function a.getNumberAt(uint256 i) external returns (uint256) envfree;
    function ao.getNumberAt(uint256 i) external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.getLength() == ao.getLength() && 
    (
        a.getLength() == 0 || 
        (forall uint256 i. (i < a.getLength() => a.getNumberAt(i) == ao.getNumberAt(i))) 
    );

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