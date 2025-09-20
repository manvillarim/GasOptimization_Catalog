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

// Ghost variables para rastrear o estado
ghost mapping(uint256 => uint256) compactToSparse;  // índice array -> índice mapping
ghost mapping(uint256 => uint256) sparseToCompact;  // índice mapping -> índice array
ghost mapping(uint256 => bool) ghostExists;         // replica ao.exists
ghost mapping(uint256 => uint256) ghostAoValues;    // replica ao.values
ghost mapping(uint256 => uint256) ghostAValues;     // replica a.values
ghost mathint ghostElementCount;
ghost mathint ghostNextIndex;

// Hook para rastrear mudanças no mapping exists
hook Sstore ao.exists[KEY uint256 j] bool newExists (bool oldExists) {
    ghostExists[j] = newExists;
    
    // Adição de elemento
    if (!oldExists && newExists) {
        mathint currentCount = ghostElementCount;
        require currentCount >= 0 && currentCount < max_uint256;
        uint256 countAsUint = require_uint256(currentCount);
        
        // Atualizar os mapeamentos
        compactToSparse[countAsUint] = j;
        sparseToCompact[j] = countAsUint;
        ghostElementCount = currentCount + 1;
    }
    
    // Remoção de elemento
    if (oldExists && !newExists) {
        uint256 indexToRemove = sparseToCompact[j];
        mathint currentCount = ghostElementCount;
        require currentCount > 0;
        uint256 lastIndex = require_uint256(currentCount - 1);
        
        // Se não é o último elemento, mover o último para esta posição
        if (indexToRemove < lastIndex) {
            uint256 lastElement = compactToSparse[lastIndex];
            compactToSparse[indexToRemove] = lastElement;
            sparseToCompact[lastElement] = indexToRemove;
        }
        
        // Limpar as referências
        sparseToCompact[j] = 0;
        ghostElementCount = currentCount - 1;
    }
}

// Hook para rastrear valores em Ao
hook Sstore ao.values[KEY uint256 j] uint256 newValue (uint256 oldValue) {
    ghostAoValues[j] = newValue;
}

// Hook para rastrear valores em A
hook Sstore a.values[KEY uint256 k] uint256 newValue (uint256 oldValue) {
    ghostAValues[k] = newValue;
}

// Hook para rastrear nextIndex
hook Sstore ao.nextIndex uint256 newNext (uint256 oldNext) {
    ghostNextIndex = to_mathint(newNext);
}

// Hook para elementCount
hook Sstore a.elementCount uint256 newCount (uint256 oldCount) {
    ghostElementCount = to_mathint(newCount);
}

hook Sstore ao.elementCount uint256 newCount (uint256 oldCount) {
    ghostElementCount = to_mathint(newCount);
}

// Definições auxiliares sem chamadas a contratos
definition isValidCompactIndex(uint256 k) returns bool =
    to_mathint(k) < ghostElementCount;

definition isValidSparseIndex(uint256 j) returns bool =
    to_mathint(j) < ghostNextIndex;

// Invariante de coupling reformulado sem chamadas a contratos dentro de quantificadores
definition couplingInv() returns bool =
    // Equivalência das variáveis de estado básicas
    (a.totalSum == ao.totalSum) &&
    (a.elementCount == ao.elementCount) &&
    (ghostElementCount == to_mathint(ao.elementCount)) &&
    (ghostElementCount == to_mathint(a.elementCount)) &&
    (ghostNextIndex == to_mathint(ao.nextIndex)) &&
    (a.lastAdded == ao.lastAdded) &&
    (a.lastRemoved == ao.lastRemoved) &&
    (a.operationCount == ao.operationCount) &&
    
    // Invariante 1: Para cada posição válida no array, existe elemento correspondente
    (forall uint256 k. 
        isValidCompactIndex(k) =>
            (ghostExists[compactToSparse[k]] &&
             ghostAValues[k] == ghostAoValues[compactToSparse[k]])
    ) &&
    
    // Invariante 2: O mapeamento é injetivo (sem duplicatas)
    (forall uint256 k1. forall uint256 k2.
        (isValidCompactIndex(k1) && isValidCompactIndex(k2) && k1 != k2) =>
        compactToSparse[k1] != compactToSparse[k2]
    ) &&
    
    // Invariante 3: sparseToCompact é consistente com compactToSparse para elementos existentes
    (forall uint256 k.
        isValidCompactIndex(k) =>
        (sparseToCompact[compactToSparse[k]] == k)
    ) &&
    
    // Invariante 4: Todo elemento existente tem índice válido no array compacto
    (forall uint256 j.
        (isValidSparseIndex(j) && ghostExists[j]) =>
        (to_mathint(sparseToCompact[j]) < ghostElementCount &&
         compactToSparse[sparseToCompact[j]] == j)
    );

// Função genérica para verificar corretude da otimização
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;

    // Sincronizar estado inicial dos ghosts com os contratos
    require ghostElementCount == to_mathint(a.elementCount);
    require ghostElementCount == to_mathint(ao.elementCount);
    require ghostNextIndex == to_mathint(ao.nextIndex);
    
    // Sincronizar os valores ghost com os valores reais
    require forall uint256 k. isValidCompactIndex(k) => ghostAValues[k] == a.values[k];
    require forall uint256 j. isValidSparseIndex(j) => ghostAoValues[j] == ao.values[j];
    require forall uint256 j. isValidSparseIndex(j) => ghostExists[j] == ao.exists[j];
    
    require couplingInv();

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}

// Rules para cada método
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