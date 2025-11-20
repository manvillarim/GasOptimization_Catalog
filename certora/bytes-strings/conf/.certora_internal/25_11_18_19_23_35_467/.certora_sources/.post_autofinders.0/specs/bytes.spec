using A as a;
using Ao as ao;

methods {
    // Expor funções públicas para o Certora
    function a.names(uint256) external returns (string) envfree;
    function ao.names(uint256) external returns (bytes) envfree;
    function a.userNames(address) external returns (string) envfree;
    function ao.userNames(address) external returns (bytes) envfree;
}

// Helper ghost para comparar string com bytes
ghost mapping(uint256 => bytes32) ghostHashA;
ghost mapping(uint256 => bytes32) ghostHashAo;

// Axioma: se os hashes são iguais, os conteúdos são equivalentes
definition stringsEquivalent(string s, bytes b) returns bool = 
    keccak256(s) == keccak256(b);

definition couplingInv() returns bool =
    a.names.length == ao.names.length &&
    (forall uint256 i. (i < a.names.length) => 
        stringsEquivalent(a.names[i], ao.names[i])) &&
    (forall address user. 
        stringsEquivalent(a.userNames[user], ao.userNames[user]));

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo;
    require couplingInv();
    
    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;
    
    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;
    
    assert a_reverted == ao_reverted;
    assert couplingInv();
}

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