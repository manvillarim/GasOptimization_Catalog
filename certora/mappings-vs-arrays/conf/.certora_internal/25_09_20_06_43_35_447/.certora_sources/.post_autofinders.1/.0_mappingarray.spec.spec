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
    function ao.getNextAvailableIndex() internal returns (uint256) envfree;
}

// Ghost para rastrear valores do array A
ghost mapping(uint256 => uint256) ghostAValues;
ghost mathint ghostALength;

// Ghost para rastrear valores e índices em Ao
ghost mapping(uint256 => uint256) ghostAoValues;        // valores no storage de Ao
ghost mapping(uint256 => uint256) ghostActiveIndices;   // array de índices ativos
ghost mathint ghostAoLength;
ghost mapping(uint256 => uint256) ghostIndexPosition;

// Hooks para Contract A

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

// Hooks para Contract Ao (versão corrigida)
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
// Invariante de equivalência refinado
definition couplingInv() returns bool =
    // 1. Estados básicos devem ser idênticos
    (a.totalSum == ao.totalSum) &&
    (a.elementCount == ao.elementCount) &&
    (a.lastAdded == ao.lastAdded) &&
    (a.lastRemoved == ao.lastRemoved) &&
    (a.operationCount == ao.operationCount) &&
    
    // 2. Comprimento dos arrays devem ser iguais
    (ao.getNextAvailableIndex() == ghostAoLength) &&
    (ghostALength == ghostAoLength) &&
    (to_mathint(a.values.length) == to_mathint(ao.activeIndices.length)) &&
    
    // 3. Para cada índice válido, os valores devem corresponder
    (forall uint256 i. 
        (to_mathint(i) < ghostALength) =>
            (ghostAValues[i] == ghostAoValues[ghostActiveIndices[i]])
    ) &&
    
    // 4. Ao deve manter índices únicos em activeIndices
    (forall uint256 i. forall uint256 j.
        ((to_mathint(i) < ghostAoLength) && 
         (to_mathint(j) < ghostAoLength) && 
         (i != j)) =>
        (ghostActiveIndices[i] != ghostActiveIndices[j])
    ) &&

    // 5. NOVA REGRA: Consistência interna do indexPosition em Ao
    (forall uint256 i.
        (to_mathint(i) < ghostAoLength) =>
            (ghostIndexPosition[ghostActiveIndices[i]] == i)
    );

// Função genérica para verificar corretude da otimização
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();
    
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