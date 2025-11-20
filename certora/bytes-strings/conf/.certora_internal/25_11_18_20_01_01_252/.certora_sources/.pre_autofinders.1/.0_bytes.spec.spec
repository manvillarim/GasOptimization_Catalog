using A as a;
using Ao as ao;

methods {
    // Funções de alteração de estado
    function a.addName(string) external envfree;
    function ao.addName(bytes) external envfree;
    function a.setUserName(address, string) external envfree;
    function ao.setUserName(address, bytes) external envfree;
    
    // Funções view/pure - TODAS AS LINHAS TERMINAM COM PONTO E VÍRGULA (;)
    // Linha 25
    function a.getUserName(address) external envfree ;
    // Linha 26
    function ao.getUserName(address) external envfree ;
    // Linha 27
    function a.getNameAt(uint256) external envfree;
    // Linha 28
    function ao.getNameAt(uint256) external  envfree;
    // Linha 29
    function a.compareNames(string, string) external envfree;
    // Linha 30
    function ao.compareNames(bytes, bytes) external envfree;
}
definition to_hash(string s) returns bytes32 = keccak256(abi.encodePacked(s)); 
// Linha 6
definition to_hash(bytes b) returns bytes32 = keccak256(b);
// --- INVARIANTE DE ACOPLAMENTO ---
definition couplingInv() returns bool =
    a.names.length == ao.names.length &&
    (forall uint256 i. (i < a.names.length) => 
        to_hash(a.names[i]) == to_hash(ao.names[i])) &&
    (forall address user. 
        to_hash(a.userNames[user]) == to_hash(ao.userNames[user]));


// --- FUNÇÃO GENÉRICA DE CORREÇÃO (ESTRUTURA MANTIDA) ---
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;
    
    require couplingInv();
    
    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;
    
    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;
    
    assert a_reverted == ao_reverted;
    
    if (!a_reverted) {
        assert couplingInv();
    }
}

// --- REGRAS DE VERIFICAÇÃO ---
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