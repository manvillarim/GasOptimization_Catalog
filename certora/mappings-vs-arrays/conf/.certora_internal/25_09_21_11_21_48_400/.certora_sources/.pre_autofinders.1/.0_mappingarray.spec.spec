using A as a;
using Ao as ao;

methods {
    function a.totalSum() external returns (uint256) envfree;
    function a.elementCount() external returns (uint256) envfree;
    function a.lastAdded() external returns (uint256) envfree;
    function a.lastRemoved() external returns (uint256) envfree;
    function a.operationCount() external returns (uint256) envfree;
    function a.values(uint256) external returns (uint256) envfree;
    function a.getLength() external returns (uint256) envfree;
    function ao.totalSum() external returns (uint256) envfree;
    function ao.elementCount() external returns (uint256) envfree;
    function ao.lastAdded() external returns (uint256) envfree;
    function ao.lastRemoved() external returns (uint256) envfree;
    function ao.operationCount() external returns (uint256) envfree;
    function ao.values(uint256) external returns (uint256) envfree;
    function ao.exists(uint256) external returns (bool) envfree;
    function ao.getLength() external returns (uint256) envfree;
    function ao.activeIndices(uint256) external returns (uint256) envfree;
}

// Ghost for A
ghost mapping(uint256 => uint256) ghostAValues;
ghost mathint ghostALength;

// Ghost for Ao
ghost mapping(uint256 => uint256) ghostAoValues;        // Ao storage values
ghost mapping(uint256 => uint256) ghostActiveIndices;   // activeIndices array
ghost mathint ghostAoLength;                            // activeIndices.length
ghost mapping(uint256 => uint256) ghostIndexPosition;   // reverse mapping
ghost uint256 ghostNextAvailableIndex;                  // nextAvailableIndex counter

// Hooks for Contract A
hook Sstore a.values[INDEX uint256 k] uint256 newValue (uint256 oldValue) {
    ghostAValues[k] = newValue;
}

hook Sload uint256 val a.values[INDEX uint256 k] {
    require ghostAValues[k] == val;
}

hook Sstore a.values.length uint256 newLen (uint256 oldLen) {
    ghostALength = to_mathint(newLen);
}

hook Sload uint256 len a.values.length {
    require ghostALength == to_mathint(len);
}

// Hooks for Ao
hook Sstore ao.values[KEY uint256 k] uint256 newValue (uint256 oldValue) {
    ghostAoValues[k] = newValue;
}

hook Sload uint256 val ao.values[KEY uint256 k] {
    require ghostAoValues[k] == val;
}

hook Sstore ao.activeIndices[INDEX uint256 k] uint256 newValue (uint256 oldValue) {
    ghostActiveIndices[k] = newValue;
}

hook Sload uint256 val ao.activeIndices[INDEX uint256 k] {
    require ghostActiveIndices[k] == val;
}

hook Sstore ao.activeIndices.length uint256 newLen (uint256 oldLen) {
    ghostAoLength = to_mathint(newLen);
}

hook Sload uint256 len ao.activeIndices.length {
    require ghostAoLength == to_mathint(len);
}

hook Sstore ao.indexPosition[KEY uint256 k] uint256 newValue (uint256 oldValue) {
    ghostIndexPosition[k] = newValue;
}

hook Sload uint256 val ao.indexPosition[KEY uint256 k] {
    require ghostIndexPosition[k] == val;
}

hook Sstore ao.nextAvailableIndex uint256 newValue (uint256 oldValue) {
    ghostNextAvailableIndex = newValue;
}

hook Sload uint256 val ao.nextAvailableIndex {
    require ghostNextAvailableIndex == val;
}

// Comprehensive coupling invariant
definition couplingInv() returns bool =
    // 1. Basic State Variables must remain the same
    (a.totalSum == ao.totalSum) &&
    (a.elementCount == ao.elementCount) &&
    (a.lastAdded == ao.lastAdded) &&
    (a.lastRemoved == ao.lastRemoved) &&
    (a.operationCount == ao.operationCount) &&
    
    // 2. Length must be equal
    (ghostALength == ghostAoLength) &&
    (to_mathint(a.getLength()) == to_mathint(ao.getLength())) &&
    
    // 3. For each valid index, the values must be equal
    (forall uint256 i. 
        (to_mathint(i) < ghostALength) =>
            (ghostAValues[i] == ghostAoValues[ghostActiveIndices[i]])
    ) &&
    
    // 4. Ao must maintain unique indices in activeIndices
    (forall uint256 i. forall uint256 j.
        ((to_mathint(i) < ghostAoLength) && 
         (to_mathint(j) < ghostAoLength) && 
         (i != j)) =>
        (ghostActiveIndices[i] != ghostActiveIndices[j])
    ) &&
    
    // 5. Bidirectional consistency of indexPosition mapping
    (forall uint256 i.
        (to_mathint(i) < ghostAoLength) =>
            (ghostIndexPosition[ghostActiveIndices[i]] == i)
    ) &&
    
    // 6. nextAvailableIndex is consistent
    (ghostNextAvailableIndex >= to_mathint(ghostAoLength)) &&
    
    // 7. All activeIndices are less than nextAvailableIndex
    (forall uint256 i.
        (to_mathint(i) < ghostAoLength) =>
            (ghostActiveIndices[i] < ghostNextAvailableIndex)
    ) &&
    
    // 8. Values outside activeIndices should be zero/deleted in Ao
    (forall uint256 k.
        ((forall uint256 i. (to_mathint(i) < ghostAoLength) => (ghostActiveIndices[i] != k))) =>
            (ghostAoValues[k] == 0)
    ) &&
    
    // 9. indexPosition should be zero for non-active indices
    (forall uint256 k.
        ((forall uint256 i. (to_mathint(i) < ghostAoLength) => (ghostActiveIndices[i] != k))) =>
            (ghostIndexPosition[k] == 0)
    );

// Generic function for gas optimization correctness
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    // Ensure same environment and initial coupling
    require eA == eAo && couplingInv();
    
    // Execute both methods
    a.f(eA, args);
    ao.g(eAo, args);
    
    // Assert coupling is maintained
    assert couplingInv();
}

// Individual rules for each method pair
rule gasOptimizedCorrectnessOfAddValue(method f, method g)
filtered {
    f -> f.selector == sig:a.addValue(uint256).selector,
    g -> g.selector == sig:ao.addValue(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUpdateValue(method f, method g)
filtered {
    f -> f.selector == sig:a.updateValue(uint256,uint256).selector,
    g -> g.selector == sig:ao.updateValue(uint256,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfRemoveValue(method f, method g)
filtered {
    f -> f.selector == sig:a.removeValue(uint256).selector,
    g -> g.selector == sig:ao.removeValue(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetValue(method f, method g)
filtered {
    f -> f.selector == sig:a.getValue(uint256).selector,
    g -> g.selector == sig:ao.getValue(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBatchAdd(method f, method g)
filtered {
    f -> f.selector == sig:a.batchAdd(uint256[]).selector,
    g -> g.selector == sig:ao.batchAdd(uint256[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfClear(method f, method g)
filtered {
    f -> f.selector == sig:a.clear().selector,
    g -> g.selector == sig:ao.clear().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetState(method f, method g)
filtered {
    f -> f.selector == sig:a.getState().selector,
    g -> g.selector == sig:ao.getState().selector
} {
    gasOptimizationCorrectness(f, g);
}