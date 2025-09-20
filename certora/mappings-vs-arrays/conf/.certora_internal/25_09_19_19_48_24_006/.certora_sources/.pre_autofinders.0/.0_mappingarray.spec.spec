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
ghost mathint ghostElementCount;

hook Sstore ao.exists[KEY uint256 j] bool newExists (bool oldExists) {
    // Adição (newExists true, oldExists false)
    if (!oldExists && newExists) {
        mathint old_len = ghostElementCount;
        // Reordenar: primeiro a atribuição simples, depois o forall
        havoc compactToSparse assuming
            (compactToSparse@new[old_len] == j) &&
            (forall uint256 k. to_mathint(k) < old_len => compactToSparse@new[k] == compactToSparse@old[k]);
        
        ghostElementCount = old_len + 1;
    }

    // Remoção (oldExists true, newExists false)
    if (oldExists && !newExists) {
        mathint old_len = ghostElementCount;

        // Simplificação máxima: apenas decrementar o contador
        // O invariante será responsável por manter a consistência
        ghostElementCount = old_len - 1;
    }
}

definition isKthActiveElement(uint256 j, uint256 k) returns bool =
    ao.exists(j) && compactToSparse[k] == j;

definition couplingInv() returns bool =
    // Equivalência das variáveis de estado básicas
    (a.totalSum == ao.totalSum) &&
    (a.elementCount == ao.elementCount) &&
    (ghostElementCount == to_mathint(ao.elementCount)) &&
    (a.lastAdded == ao.lastAdded) &&
    (a.lastRemoved == ao.lastRemoved) &&
    (a.operationCount == ao.operationCount) &&
    
    // Invariante: para cada posição k no array A, existe um elemento ativo correspondente em Ao
    (forall uint256 k. 
        (to_mathint(k) < ghostElementCount) =>
            (ao.exists[compactToSparse[k]] &&
             a.values[k] == ao.values[compactToSparse[k]])
    ) &&

    // Invariante: cada elemento existente em Ao tem uma posição correspondente no array A
    (forall uint256 j.
        ao.exists[j] => (exists uint256 k. to_mathint(k) < ghostElementCount && compactToSparse[k] == j)
    ) &&
    
    // Invariante adicional: compactToSparse é uma bijeção entre [0, elementCount) e elementos ativos
    (forall uint256 k1. forall uint256 k2.
        (to_mathint(k1) < ghostElementCount && to_mathint(k2) < ghostElementCount && k1 != k2) =>
        compactToSparse[k1] != compactToSparse[k2]
    );

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

// Rules
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