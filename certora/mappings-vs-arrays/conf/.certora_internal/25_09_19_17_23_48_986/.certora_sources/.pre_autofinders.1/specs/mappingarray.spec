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

definition couplingInv() returns bool =

    (forall uint256 i. (i < a.values.length && ao.exists[i]) => a.values[i] == ao.values[i]) &&
    a.totalSum == ao.totalSum &&
    a.elementCount == ao.elementCount &&
    a.lastAdded == ao.lastAdded &&
    a.lastRemoved == ao.lastRemoved &&
    a.operationCount == ao.operationCount &&
    
    a.getLength() == ao.elementCount;

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
    gasOptimizationCorrectness(f, g);
}

// Rule for updateValue equivalence
rule gasOptimizedCorrectnessOfUpdateValue(method f, method g)
filtered {
    f -> f.selector == sig:a.updateValue(uint256,uint256).selector,
    g -> g.selector == sig:ao.updateValue(uint256,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for removeValue
rule gasOptimizedCorrectnessOfRemoveValue(method f, method g)
filtered {
    f -> f.selector == sig:a.removeValue(uint256).selector,
    g -> g.selector == sig:ao.removeValue(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for getValue equivalence
rule gasOptimizedCorrectnessOfGetValue(method f, method g)
filtered {
    f -> f.selector == sig:a.getValue(uint256).selector,
    g -> g.selector == sig:ao.getValue(uint256).selector
} {
    gasOptimizationCorrectness(f, g);

}

// Rule for batchAdd 
rule gasOptimizedCorrectnessOfBatchAdd(method f, method g)
filtered {
    f -> f.selector == sig:a.batchAdd(uint256[]).selector,
    g -> g.selector == sig:ao.batchAdd(uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for clear 
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
    gasOptimizationCorrectness(f, g);

}