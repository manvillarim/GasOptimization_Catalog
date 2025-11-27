using A as a;
using Ao as ao;

methods {
    // Contract A methods
    function a.totalSum() external returns (uint256) envfree;
    function a.totalCount() external returns (uint256) envfree;
    function a.lastAverage() external returns (uint256) envfree;
    function a.processedArrays() external returns (uint256) envfree;
    function a.maxValue() external returns (uint256) envfree;
    function a.minValue() external returns (uint256) envfree;
    
    // Contract Ao methods  
    function ao.totalSum() external returns (uint256) envfree;
    function ao.totalCount() external returns (uint256) envfree;
    function ao.lastAverage() external returns (uint256) envfree;
    function ao.processedArrays() external returns (uint256) envfree;
    function ao.maxValue() external returns (uint256) envfree;
    function ao.minValue() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.totalSum == ao.totalSum &&
    a.totalCount == ao.totalCount &&
    a.lastAverage == ao.lastAverage &&
    a.processedArrays == ao.processedArrays &&
    a.maxValue == ao.maxValue &&
    a.minValue == ao.minValue;

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

// Rule for processArray equivalence
rule gasOptimizedCorrectnessOfProcessArray(method f, method g)
filtered {
    f -> f.selector == sig:a.processArray(uint256[]).selector,
    g -> g.selector == sig:ao.processArray(uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for calculateStats equivalence
rule gasOptimizedCorrectnessOfCalculateStats(method f, method g)
filtered {
    f -> f.selector == sig:a.calculateStats(uint256[]).selector,
    g -> g.selector == sig:ao.calculateStats(uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for batchProcess equivalence
rule gasOptimizedCorrectnessOfBatchProcess(method f, method g)
filtered {
    f -> f.selector == sig:a.batchProcess(uint256[][]).selector,
    g -> g.selector == sig:ao.batchProcess(uint256[][]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for complexCalculation equivalence
rule gasOptimizedCorrectnessOfComplexCalculation(method f, method g)
filtered {
    f -> f.selector == sig:a.complexCalculation(uint256[],uint256[],uint256[]).selector,
    g -> g.selector == sig:ao.complexCalculation(uint256[],uint256[],uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for mergeSorted equivalence
rule gasOptimizedCorrectnessOfMergeSorted(method f, method g)
filtered {
    f -> f.selector == sig:a.mergeSorted(uint256[],uint256[]).selector,
    g -> g.selector == sig:ao.mergeSorted(uint256[],uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}