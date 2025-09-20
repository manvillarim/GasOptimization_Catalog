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
    function ao.nextIndex() external returns (uint256) envfree;
    function ao.getLength() external returns (uint256) envfree;
}

ghost mapping(uint256 => uint256) compactToSparse;

hook Sstore ao.exists[KEY uint256 j] bool newExists (bool oldExists) {

    if (!oldExists && newExists) { // Addition
        uint256 old_len = ao.elementCount; 
        havoc compactToSparse assuming
            // CORREÇÃO: Adicionado @old na referência ao estado anterior
            (forall uint256 k. k < old_len => compactToSparse@new[k] == compactToSparse@old[k]) &&
            (compactToSparse@new[old_len] == j);
    }

    if (oldExists && !newExists) { // Removal
        uint256 k_removed;
        // CORREÇÃO: Adicionado @old para buscar o valor no estado anterior
        require compactToSparse@old[k_removed] == j;

        havoc compactToSparse assuming forall uint256 k.
            // CORREÇÃO: Adicionado @old na referência ao estado anterior
            (k < k_removed => compactToSparse@new[k] == compactToSparse@old[k]) &&
            // CORREÇÃO: Adicionado @old na referência ao estado anterior
            (k >= k_removed && k < ao.elementCount - 1 => compactToSparse@new[k] == compactToSparse@old[to_uint256(k + 1)]);
    }
}

definition isKthActiveElement(uint256 j, uint256 k) returns bool =
    ao.exists[j] && 
    compactToSparse[k] == j;

definition couplingInv() returns bool =
    a.values.length == ao.elementCount &&
    a.totalSum == ao.totalSum &&
    a.elementCount == ao.elementCount &&
    a.lastAdded == ao.lastAdded &&
    a.lastRemoved == ao.lastRemoved &&
    a.operationCount == ao.operationCount &&
    (forall uint256 k. k < a.values.length => 
        isKthActiveElement(compactToSparse[k], k) &&
        a.values[k] == ao.values[compactToSparse[k]]);

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

// Rules (sem alterações)
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