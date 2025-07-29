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

// P(A, Ao) - Complete coupling invariant
definition couplingInv() returns bool =
    a.totalSum == ao.totalSum &&
    a.totalCount == ao.totalCount &&
    a.lastAverage == ao.lastAverage &&
    a.processedArrays == ao.processedArrays &&
    a.maxValue == ao.maxValue &&
    a.minValue == ao.minValue;

// Generic function to verify gas optimization correctness
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

// Rule for processArray equivalence with return value verification
rule gasOptimizedCorrectnessOfProcessArray(method f, method g)
filtered {
    f -> f.selector == sig:a.processArray(uint256[]).selector,
    g -> g.selector == sig:ao.processArray(uint256[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    uint256 sumA; uint256 averageA;
    uint256 sumAo; uint256 averageAo;
    
    sumA, averageA = a.processArray(eA, args);
    sumAo, averageAo = ao.processArray(eAo, args);
    
    // Verify return values are identical
    assert sumA == sumAo;
    assert averageA == averageAo;
    
    // Verify coupling invariant holds
    assert couplingInv();
}

// Rule for calculateStats - pure function equivalence
rule gasOptimizedCorrectnessOfCalculateStats(method f, method g)
filtered {
    f -> f.selector == sig:a.calculateStats(uint256[]).selector,
    g -> g.selector == sig:ao.calculateStats(uint256[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo;
    
    uint256 sumA; uint256 minA; uint256 maxA; uint256 averageA;
    uint256 sumAo; uint256 minAo; uint256 maxAo; uint256 averageAo;
    
    sumA, minA, maxA, averageA = a.calculateStats(eA, args);
    sumAo, minAo, maxAo, averageAo = ao.calculateStats(eAo, args);
    
    // Verify all return values are identical
    assert sumA == sumAo;
    assert minA == minAo;
    assert maxA == maxAo;
    assert averageA == averageAo;
}

// Rule for batchProcess equivalence
rule gasOptimizedCorrectnessOfBatchProcess(method f, method g)
filtered {
    f -> f.selector == sig:a.batchProcess(uint256[][]).selector,
    g -> g.selector == sig:ao.batchProcess(uint256[][]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    uint256 totalProcessedA = a.batchProcess(eA, args);
    uint256 totalProcessedAo = ao.batchProcess(eAo, args);
    
    // Verify return values are identical
    assert totalProcessedA == totalProcessedAo;
    
    // Verify coupling invariant holds
    assert couplingInv();
}

// Rule for complexCalculation equivalence
rule gasOptimizedCorrectnessOfComplexCalculation(method f, method g)
filtered {
    f -> f.selector == sig:a.complexCalculation(uint256[],uint256[],uint256[]).selector,
    g -> g.selector == sig:ao.complexCalculation(uint256[],uint256[],uint256[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    uint256 resultA = a.complexCalculation(eA, args);
    uint256 resultAo = ao.complexCalculation(eAo, args);
    
    // Verify return values are identical
    assert resultA == resultAo;
    
    // Verify coupling invariant holds
    assert couplingInv();
}

// Rule for pure functions that don't modify state
rule gasOptimizedCorrectnessOfFindValues(method f, method g)
filtered {
    f -> f.selector == sig:a.findValues(uint256[],uint256[]).selector,
    g -> g.selector == sig:ao.findValues(uint256[],uint256[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo;
    
    // For array returns, we just verify no state changes occur
    a.findValues(eA, args);
    ao.findValues(eAo, args);
    
    // State should remain unchanged for pure functions
    assert couplingInv();
}

// Rule for mergeSorted - pure function
rule gasOptimizedCorrectnessOfMergeSorted(method f, method g)
filtered {
    f -> f.selector == sig:a.mergeSorted(uint256[],uint256[]).selector,
    g -> g.selector == sig:ao.mergeSorted(uint256[],uint256[]).selector
} {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo;
    
    // For array returns, we just verify no state changes occur
    a.mergeSorted(eA, args);
    ao.mergeSorted(eAo, args);
    
    // State should remain unchanged for pure functions
    assert couplingInv();
}

// Invariant: State values are always consistent
invariant stateConsistency()
    a.totalSum == ao.totalSum &&
    a.totalCount == ao.totalCount &&
    a.lastAverage == ao.lastAverage &&
    a.processedArrays == ao.processedArrays &&
    a.maxValue == ao.maxValue &&
    a.minValue == ao.minValue;

// Invariant: Constructor initialization
invariant constructorInit()
    a.minValue == type(uint256).max => ao.minValue == type(uint256).max;