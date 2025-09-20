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
    // Adição (novoExists true, oldExists false)
    if (!oldExists && newExists) {
        uint256 old_len = ao.elementCount@old();
        // preserva prefixo e coloca j em compactToSparse@new[old_len]
        havoc compactToSparse assuming
            (forall uint256 k. k < old_len => compactToSparse@new[k] == compactToSparse@old[k]) &&
            (compactToSparse@new[old_len] == j);
    }

    // Remoção (oldExists true, newExists false)
    if (oldExists && !newExists) {
        uint256 old_len = ao.elementCount@old();

        // escolher um índice k_removed tal que compactToSparse@old[k_removed] == j
        uint256 k_removed;
        havoc k_removed assuming (k_removed < old_len && compactToSparse@old[k_removed] == j);

        // copiar prefixo e deslocar à esquerda o resto
        havoc compactToSparse assuming
            (forall uint256 k. k < k_removed => compactToSparse@new[k] == compactToSparse@old[k]) &&
            (forall uint256 k. (k >= k_removed && k < old_len - 1) => compactToSparse@new[k] == compactToSparse@old[k + 1]);
    }
}

definition isKthActiveElement(uint256 j, uint256 k) returns bool =
    ao.exists(j) && compactToSparse[k] == j;

definition couplingInv() returns bool =
    (a.getLength() == ao.elementCount()) &&
    (a.totalSum() == ao.totalSum()) &&
    (a.elementCount() == ao.elementCount()) &&
    (a.lastAdded() == ao.lastAdded()) &&
    (a.lastRemoved() == ao.lastRemoved()) &&
    (a.operationCount() == ao.operationCount()) &&
    
    // CORREÇÃO: Removido "uint256" da declaração de 'k'
    (forall k.
        (k < a.getLength()) =>
            (isKthActiveElement(compactToSparse[k], k) &&
             a.values(k) == ao.values(compactToSparse[k]))
    ) &&

    // CORREÇÃO: Removido "uint256" das declarações de 'j' e 'k'
    (forall j.
        ao.exists(j) => exists k. (k < a.getLength() && compactToSparse[k] == j)
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
