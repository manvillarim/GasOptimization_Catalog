using A as a;
using Ao as ao;

methods {
    function processNumbers() external;
    function incrementAll() external;
    function doubleAndAdd(uint256) external;
}

definition couplingInv() returns bool = a.numbers.length == ao.currentLength && (forall uint256 i. (i < a.numbers.length => a.numbers[i] == ao.numbers[i]));

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
filtered { f -> f.selector == a.processNumbers.selector, g -> g.selector == ao.processNumbers.selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfIncrementAll(method f, method g)
filtered { f -> f.selector == a.incrementAll.selector, g -> g.selector == ao.incrementAll.selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDoubleAndAdd(method f, method g)
filtered { f -> f.selector == sig:a.doubleAndAdd(uint256).selector, g -> g.selector == sig:ao.doubleAndAdd(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

