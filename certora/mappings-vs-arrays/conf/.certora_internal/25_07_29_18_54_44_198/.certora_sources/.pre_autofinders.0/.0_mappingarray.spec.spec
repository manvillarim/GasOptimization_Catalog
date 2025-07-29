using A as a;
using Ao as ao;

methods {
    // Contract A methods
    function a.totalSum() external returns (uint256) envfree;
    function a.elementCount() external returns (uint256) envfree;
    function a.lastAdded() external returns (uint256) envfree;
    function a.lastRemoved() external returns (uint256) envfree;
    function a.operationCount() external returns (uint256) envfree;
    function a.values(uint256) external returns (uint256) envfree;
    function a.getLength() external returns (uint256) envfree;
    
    // Contract Ao methods
    function ao.totalSum() external returns (uint256) envfree;
    function ao.elementCount() external returns (uint256) envfree;
    function ao.lastAdded() external returns (uint256) envfree;
    function ao.lastRemoved() external returns (uint256) envfree;
    function ao.operationCount() external returns (uint256) envfree;
    function ao.values(uint256) external returns (uint256) envfree;
    function ao.exists(uint256) external returns (bool) envfree;
    function ao.nextIndex() external returns (uint256) envfree;
    function ao.getLength() external returns (uint256) envfree;
}

// P(A, Ao) - Complete coupling invariant
definition couplingInv() returns bool =
    // Relação 1: Equivalência de estado global
    a.totalSum == ao.totalSum &&
    a.elementCount == ao.elementCount &&
    a.lastAdded == ao.lastAdded &&
    a.lastRemoved == ao.lastRemoved &&
    a.operationCount == ao.operationCount &&
    
    // Relação 4: Consistência de contagem
    a.getLength() == ao.elementCount;

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

// Rule for addValue equivalence
rule gasOptimizedCorrectnessOfAddValue(method f, method g)
filtered {
    f -> f.selector == sig:a.addValue(uint256).selector,
    g -> g.selector == sig:ao.addValue(uint256).selector
} {
    env eA;
    env eAo;
    uint256 value;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    uint256 indexA = a.addValue(eA, value);
    uint256 indexAo = ao.addValue(eAo, value);
    
    // Both should add at sequential indices
    assert couplingInv();
}

// Rule for updateValue equivalence
rule gasOptimizedCorrectnessOfUpdateValue(method f, method g)
filtered {
    f -> f.selector == sig:a.updateValue(uint256,uint256).selector,
    g -> g.selector == sig:ao.updateValue(uint256,uint256).selector
} {
    env eA;
    env eAo;
    uint256 index;
    uint256 newValue;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    // Ensure the index exists in both contracts
    require index < a.getLength();
    require ao.exists[index];
    
    // Ensure same initial value
    require a.values[index] == ao.values[index];
    
    a.updateValue(eA, index, newValue);
    ao.updateValue(eAo, index, newValue);
    
    assert couplingInv();
}

// Rule for removeValue - simplified version
rule gasOptimizedCorrectnessOfRemoveValue(method f, method g)
filtered {
    f -> f.selector == sig:a.removeValue(uint256).selector,
    g -> g.selector == sig:ao.removeValue(uint256).selector
} {
    env eA;
    env eAo;
    uint256 index;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    // Only test removal when index exists in both
    require index < a.getLength();
    require ao.exists[index];
    require a.values[index] == ao.values[index];
    
    // Store value before removal
    uint256 valueToRemove = a.values[index];
    
    a.removeValue(eA, index);
    ao.removeValue(eAo, index);
    
    // Verify state consistency after removal
    assert a.totalSum == ao.totalSum;
    assert a.elementCount == ao.elementCount;
    assert a.lastRemoved == ao.lastRemoved;
    assert a.lastRemoved == valueToRemove;
    assert couplingInv();
}

// Rule for getValue equivalence
rule gasOptimizedCorrectnessOfGetValue(method f, method g)
filtered {
    f -> f.selector == sig:a.getValue(uint256).selector,
    g -> g.selector == sig:ao.getValue(uint256).selector
} {
    env eA;
    env eAo;
    uint256 index;
    
    require eA == eAo;
    require couplingInv();
    
    // Only test when index exists in both
    require index < a.getLength();
    require ao.exists[index];
    require a.values[index] == ao.values[index];
    
    uint256 valueA = a.getValue(eA, index);
    uint256 valueAo = ao.getValue(eAo, index);
    
    assert valueA == valueAo;
}

// Rule for batchAdd using generic function
rule gasOptimizedCorrectnessOfBatchAdd(method f, method g)
filtered {
    f -> f.selector == sig:a.batchAdd(uint256[]).selector,
    g -> g.selector == sig:ao.batchAdd(uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for clear using generic function
rule gasOptimizedCorrectnessOfClear(method f, method g)
filtered {
    f -> f.selector == sig:a.clear().selector,
    g -> g.selector == sig:ao.clear().selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for getState equivalence
rule gasOptimizedCorrectnessOfGetState(method f, method g)
filtered {
    f -> f.selector == sig:a.getState().selector,
    g -> g.selector == sig:ao.getState().selector
} {
    env eA;
    env eAo;
    
    require eA == eAo && couplingInv();
    
    uint256 totalSumA; uint256 elementCountA; uint256 lastAddedA; 
    uint256 lastRemovedA; uint256 operationCountA; uint256 lengthA;
    
    uint256 totalSumAo; uint256 elementCountAo; uint256 lastAddedAo;
    uint256 lastRemovedAo; uint256 operationCountAo; uint256 lengthAo;
    
    totalSumA, elementCountA, lastAddedA, lastRemovedA, operationCountA, lengthA = a.getState(eA);
    totalSumAo, elementCountAo, lastAddedAo, lastRemovedAo, operationCountAo, lengthAo = ao.getState(eAo);
    
    assert totalSumA == totalSumAo;
    assert elementCountA == elementCountAo;
    assert lastAddedA == lastAddedAo;
    assert lastRemovedA == lastRemovedAo;
    assert operationCountA == operationCountAo;
    assert lengthA == lengthAo; // Both should return elementCount
}