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

// Ghost mappings para rastrear o mapeamento entre array e mapping
ghost mapping(uint256 => uint256) compactToSparse;  // posição no array A -> chave em Ao
ghost mapping(uint256 => uint256) sparseToCompact;  // chave em Ao -> posição no array A
ghost mapping(uint256 => bool) ghostExists;         // replica de ao.exists
ghost mapping(uint256 => uint256) ghostAValues;     // replica de a.values
ghost mapping(uint256 => uint256) ghostAoValues;    // replica de ao.values
ghost mathint ghostElementCount;
ghost mathint ghostNextIndex;
ghost mathint ghostArrayLength;

// Inicialização dos ghosts
hook Sload uint256 val a.elementCount {
    require ghostElementCount == to_mathint(val);
}

hook Sstore a.elementCount uint256 newVal (uint256 oldVal) {
    ghostElementCount = to_mathint(newVal);
}

hook Sload uint256 val ao.nextIndex {
    require ghostNextIndex == to_mathint(val);
}

hook Sstore ao.nextIndex uint256 newVal (uint256 oldVal)  {
    ghostNextIndex = to_mathint(newVal);
}

// Hook para rastrear valores no array A
hook Sstore a.values[INDEX uint256 k] uint256 newValue (uint256 oldValue) {
    ghostAValues[k] = newValue;
}

hook Sload uint256 val a.values[INDEX uint256 k] {
    require ghostAValues[k] == val;
}

// Hook para rastrear valores no mapping Ao
hook Sstore ao.values[KEY uint256 j] uint256 newValue (uint256 oldValue) {
    ghostAoValues[j] = newValue;
}

hook Sload uint256 val ao.values[KEY uint256 j] {
    require ghostAoValues[j] == val;
}

// Hook para rastrear exists no mapping Ao - CORRIGIDO
hook Sstore ao.exists[KEY uint256 j] bool newExists (bool oldExists) {
    ghostExists[j] = newExists;
    
    // Quando um novo elemento é adicionado em Ao
    if (!oldExists && newExists) {
        // O novo elemento vai para a próxima posição do array
        uint256 arrayPos = require_uint256(ghostElementCount);
        compactToSparse[arrayPos] = j;
        sparseToCompact[j] = arrayPos;
    }
    
    // Quando um elemento é removido de Ao
    if (oldExists && !newExists) {
        uint256 removedPos = sparseToCompact[j];
        // CORREÇÃO: usar ghostElementCount atual, não decrementado
        uint256 lastPos = require_uint256(ghostElementCount - 1);
        
        // Se não é o último elemento, precisamos simular o shift do array A
        if (removedPos < lastPos) {
            // Simular o deslocamento: todos elementos após removedPos são movidos uma posição para trás
            // Precisamos atualizar os mapeamentos para refletir essa reorganização
            
            // Em um loop, moveríamos todos os elementos, mas isso é custoso
            // Alternativa: mapear a última posição para a posição removida
            uint256 lastKey = compactToSparse[lastPos];
            
            // Mover o elemento da última posição para a posição removida
            compactToSparse[removedPos] = lastKey;
            sparseToCompact[lastKey] = removedPos;
            
            // A última posição agora fica inválida (será tratada pela redução do elementCount)
            compactToSparse[lastPos] = 0;
        }
        
        // Limpar mapeamentos para a chave removida
        sparseToCompact[j] = 0;
    }
}

hook Sload bool val ao.exists[KEY uint256 j] {
    require ghostExists[j] == val;
}

// Hook para rastrear o comprimento do array
hook Sload uint256 len a.values.length {
    require ghostArrayLength == to_mathint(len);
}

hook Sstore a.values.length uint256 newLen (uint256 oldLen) {
    ghostArrayLength = to_mathint(newLen);
}

// Definição do invariante de coupling - CORRIGIDO
definition couplingInv() returns bool =
    // 1. Equivalência das variáveis de estado
    (a.totalSum() == ao.totalSum()) &&
    (a.elementCount() == ao.elementCount()) &&
    (ghostElementCount == to_mathint(ao.elementCount())) &&
    (ghostElementCount == to_mathint(a.elementCount())) &&
    (a.lastAdded() == ao.lastAdded()) &&
    (a.lastRemoved() == ao.lastRemoved()) &&
    (a.operationCount() == ao.operationCount()) &&
    (ghostArrayLength == ghostElementCount) &&
    
    // 2. Para cada posição válida no array, o valor corresponde ao valor em Ao na chave mapeada
    (forall uint256 k. 
        (to_mathint(k) < ghostElementCount) =>
            (ghostExists[compactToSparse[k]] &&
             ghostAValues[k] == ghostAoValues[compactToSparse[k]])
    ) &&
    
    // 3. O mapeamento compactToSparse é injetivo (sem duplicatas)
    (forall uint256 k1. forall uint256 k2.
        ((to_mathint(k1) < ghostElementCount) && 
         (to_mathint(k2) < ghostElementCount) && 
         (k1 != k2)) =>
        (compactToSparse[k1] != compactToSparse[k2])
    ) &&
    
    // 4. sparseToCompact é consistente com compactToSparse
    (forall uint256 k.
        (to_mathint(k) < ghostElementCount) =>
        (sparseToCompact[compactToSparse[k]] == k)
    ) &&
    
    // 5. Todo elemento existente em Ao tem uma posição válida no array A
    (forall uint256 j.
        (ghostExists[j]) =>
        ((to_mathint(sparseToCompact[j]) < ghostElementCount) &&
         (compactToSparse[sparseToCompact[j]] == j))
    ) &&
    
    // 6. CORREÇÃO: Elementos não existentes em Ao não têm mapeamento válido
    // Removemos a restrição de j < ghostNextIndex que causava problemas
    (forall uint256 j.
        (!ghostExists[j]) =>
        (forall uint256 pos. 
            (to_mathint(pos) < ghostElementCount) => (compactToSparse[pos] != j))
    ) &&
    
    // 7. ADIÇÃO: Consistência do nextIndex - elementos só podem existir até nextIndex-1
    (forall uint256 j.
        (to_mathint(j) >= ghostNextIndex) => (!ghostExists[j])
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
    
    // Pre-condição: invariante de coupling deve valer
    require couplingInv();
    
    // Executar as operações
    a.f(eA, args);
    ao.g(eAo, args);
    
    // Pós-condição: invariante de coupling deve continuar valendo
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