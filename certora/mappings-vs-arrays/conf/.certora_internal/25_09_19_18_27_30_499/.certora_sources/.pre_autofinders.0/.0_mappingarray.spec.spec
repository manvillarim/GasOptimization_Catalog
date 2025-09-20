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

// Ghost: mapeia posição k no array compactado para índice j no mapping com gaps
ghost mapping(uint256 => uint256) compactToSparse;
// Ghost: conta quantos elementos ativos existem antes de cada índice no mapping
ghost mapping(uint256 => uint256) activeCountBefore;

// Hook para rastrear quando adicionamos valores (ambos contratos adicionam no mesmo índice)
hook Sstore ao.values[KEY uint256 j] uint256 newVal (uint256 oldVal) {
    if (!ao.exists[j] && newVal != 0) {
        // Novo elemento adicionado no índice j
        uint256 currentArrayLength = a.values.length;
        // Mapeia posição do array para índice do mapping
        havoc compactToSparse assuming compactToSparse@new[currentArrayLength] == j;
    }
}

// Hook para rastrear remoções e atualizar mapeamento
hook Sstore ao.exists[KEY uint256 j] bool newExists (bool oldExists) {
    if (oldExists && !newExists) {
        // Elemento removido no índice j - precisa atualizar mapeamento
        // Todos os elementos do array após a posição removida serão shiftados
        havoc compactToSparse assuming forall uint256 k. (
            // Se k era mapeado para um índice > j, continua mapeado para o mesmo
            (compactToSparse@old[k] > j => compactToSparse@new[k] == compactToSparse@old[k]) &&
            // Se k era mapeado para índices < j, continua mapeado para o mesmo  
            (compactToSparse@old[k] < j => compactToSparse@new[k] == compactToSparse@old[k])
        );
    }
}

// Definição auxiliar: verifica se o índice j é o k-ésimo elemento ativo
// CORRIGIDO: usa acesso direto ao estado ao.exists[j]
definition isKthActiveElement(uint256 j, uint256 k) returns bool =
    ao.exists[j] && 
    compactToSparse[k] == j;

// Coupling invariant corrigido usando ghost mapping e acesso direto ao estado
// CORRIGIDO: usa a.values.length, a.values[k] e ao.values[key]
definition couplingInv() returns bool =
    a.values.length == ao.elementCount && // Correção: Acesso direto
    a.totalSum == ao.totalSum &&
    a.elementCount == ao.elementCount &&
    a.lastAdded == ao.lastAdded &&
    a.lastRemoved == ao.lastRemoved &&
    a.operationCount == ao.operationCount &&
    // Para cada posição k no array compactado, o valor corresponde ao mapping
    (forall uint256 k. k < a.values.length => // Correção: Acesso direto
        isKthActiveElement(compactToSparse[k], k) &&
        a.values[k] == ao.values[compactToSparse[k]]); // Correção: Acesso direto

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