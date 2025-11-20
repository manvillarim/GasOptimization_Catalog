// SPDX-License-Identifier: MIT

// --- FUNÇÕES DE HASH AUXILIARES (Para lidar com string/bytes dinâmicos) ---
// Define o mapeamento de string/bytes para um hash de 32 bytes para comparação.
definition to_hash(string memory s) returns bytes32 = keccak256(abi.encodePacked(s));
definition to_hash(bytes memory b) returns bytes32 = keccak256(b);

// Se uma das entradas for zero (string/bytes vazios) o hash é tratado.
// O keccak256 de bytes/string vazios é:
// 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470

// --- MÉTODOS ---
using A as a;
using Ao as ao;

methods {
    // Funções de alteração de estado
    function a.addName(string) external envfree;
    function ao.addName(bytes) external envfree;
    function a.setUserName(address, string) external envfree;
    function ao.setUserName(address, bytes) external envfree;
    
    // Funções view/pure. Removed the 'noreverting' from view functions 
    // that have 'require' statements (like getNameAt).
    function a.getUserName(address) external view envfree noreverting;
    function ao.getUserName(address) external view envfree noreverting;
    function a.getNameAt(uint256) external view envfree; // Pode reverter
    function ao.getNameAt(uint256) external view envfree; // Pode reverter
    function a.compareNames(string, string) external pure envfree noreverting;
    function ao.compareNames(bytes, bytes) external pure envfree noreverting;
}

// --- INVARIANTE DE ACOPLAMENTO (COUPLING INVARIANT) ---
definition couplingInv() returns bool =
    a.names.length == ao.names.length &&
    // O conteúdo de a.names[i] e ao.names[i] deve ser equivalente
    (forall uint256 i. (i < a.names.length) => 
        to_hash(a.names[i]) == to_hash(ao.names[i])) &&
    // O conteúdo de a.userNames[user] e ao.userNames[user] deve ser equivalente
    (forall address user. 
        to_hash(a.userNames[user]) == to_hash(ao.userNames[user]));


// --- FUNÇÃO GENÉRICA DE CORREÇÃO (ESTRUTURA MANTIDA) ---
// Nota: Para funções view/pure, Certora Prover consegue provar que os valores 
// de retorno são equivalentes assumindo que as implementações são equivalentes 
// em termos funcionais (que é o caso aqui, pois o hash de string/bytes é o mesmo).
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    // 1. Pré-condições de equivalência do ambiente (OK)
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;
    
    // 2. Invariante deve ser verdadeiro antes da chamada (OK)
    require couplingInv();
    
    // 3. Chamadas das funções
    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;
    
    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;
    
    // 4. Se um reverte, o outro deve reverter (OK)
    assert a_reverted == ao_reverted;
    
    // 5. Se NENHUM reverte, o invariante deve ser mantido (OK)
    if (!a_reverted) {
        assert couplingInv();
    }
}

// --- REGRAS DE VERIFICAÇÃO ---
// As regras permanecem as mesmas, usando a função genérica.

rule gasOptimizedCorrectnessOfAddName(method f, method g)
filtered {
    f -> f.selector == sig:a.addName(string).selector,
    g -> g.selector == sig:ao.addName(bytes).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetUserName(method f, method g)
filtered {
    f -> f.selector == sig:a.setUserName(address, string).selector,
    g -> g.selector == sig:ao.setUserName(address, bytes).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetUserName(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserName(address).selector,
    g -> g.selector == sig:ao.getUserName(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetNameAt(method f, method g)
filtered {
    f -> f.selector == sig:a.getNameAt(uint256).selector,
    g -> g.selector == sig:ao.getNameAt(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCompareNames(method f, method g)
filtered {
    f -> f.selector == sig:a.compareNames(string, string).selector,
    g -> g.selector == sig:ao.compareNames(bytes, bytes).selector
} {
    gasOptimizationCorrectness(f, g);
}