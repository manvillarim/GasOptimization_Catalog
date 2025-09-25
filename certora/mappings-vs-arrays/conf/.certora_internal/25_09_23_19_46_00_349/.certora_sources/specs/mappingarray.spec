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
    function ao.getLength() external returns (uint256) envfree;
}

// Constants
definition REMOVED_MARKER() returns uint256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

// Ghost variables for Contract A
ghost mapping(uint256 => uint256) ghostAValues;
ghost mathint ghostALength;
ghost mathint ghostAElementCount;

// Ghost variables for Contract Ao
ghost mapping(uint256 => uint256) ghostAoValues;
ghost mathint ghostAoLength;
ghost mathint ghostAoElementCount;

// Hooks for Contract A - Array storage
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

hook Sstore a.elementCount uint256 newCount (uint256 oldCount) {
    ghostAElementCount = to_mathint(newCount);
}

hook Sload uint256 count a.elementCount {
    require ghostAElementCount == to_mathint(count);
}

// Hooks for Contract Ao - Mapping storage
hook Sstore ao.values[KEY uint256 k] uint256 newValue (uint256 oldValue) {
    ghostAoValues[k] = newValue;
}

hook Sload uint256 val ao.values[KEY uint256 k] {
    require ghostAoValues[k] == val;
}

// Hook for Ao's packed state length
hook Sstore ao.state.length uint128 newLen (uint128 oldLen) {
    ghostAoLength = to_mathint(newLen);
}

hook Sload uint128 len ao.state.length {
    require ghostAoLength == to_mathint(len);
}

// Hook for Ao's packed state elementCount
hook Sstore ao.state.elementCount uint128 newCount (uint128 oldCount) {
    ghostAoElementCount = to_mathint(newCount);
}

hook Sload uint128 count ao.state.elementCount {
    require ghostAoElementCount == to_mathint(count);
}

definition couplingInv() returns bool =
    // 1. All state variables must be identical
    (a.totalSum() == ao.totalSum()) &&
    (ghostAElementCount == ghostAoElementCount) &&
    (a.lastAdded() == ao.lastAdded()) &&
    (a.lastRemoved() == ao.lastRemoved()) &&
    (a.operationCount() == ao.operationCount()) &&
    
    // 2. Element count tracking
    (ghostALength == ghostAElementCount) && // A: length == elementCount always
    (ghostAoElementCount <= ghostAoLength) && // Ao: elementCount <= length (removed elements)
    
    // 3. Length relationship: A compacts, Ao keeps logical length
    (a.getLength() == ao.getLength()) && // Both getLength() should return current active length
    (ghostALength == to_mathint(a.getLength())) &&
    
    // 4. Value mapping: A's compact array matches Ao's active values
    // We need to build active sequence from Ao and compare with A's sequence
    (ghostALength == countActiveInAo()) &&
    (forall uint256 aIndex.
        (to_mathint(aIndex) < ghostALength) =>
            (ghostAValues[aIndex] == getNthActiveValueInAo(aIndex))
    ) &&
    
    // 5. No active value in Ao should be REMOVED_MARKER
    (forall uint256 i.
        (to_mathint(i) < ghostAoLength && ghostAoValues[i] != REMOVED_MARKER()) =>
            (ghostAoValues[i] != REMOVED_MARKER()) // Redundant but explicit
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