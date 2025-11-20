using A as a;
using Ao as ao;

methods {
    function a.addName(string) external;
    function ao.addName(bytes) external;
    function a.setUserName(address, string) external;
    function ao.setUserName(address, bytes) external;
    function a.getUserName(address) external returns (string) envfree;
    function ao.getUserName(address) external returns (bytes) envfree;
    function a.getNameAt(uint256) external returns (string) envfree;
    function ao.getNameAt(uint256) external returns (bytes) envfree;
    function a.compareNames(string, string) external returns (bool) envfree;
    function ao.compareNames(bytes, bytes) external returns (bool) envfree;
}

// Helper para verificar equivalência de conteúdo via keccak
function checkArrayEquivalence(uint256 length) returns bool {
    bool equiv = true;
    for (uint256 i = 0; i < length && i < 10; i++) {  // Limita a 10 iterações por performance
        string nameA = a.getNameAt(i);
        bytes nameAo = ao.getNameAt(i);
        equiv = equiv && (keccak256(nameA) == keccak256(nameAo));
    }
    return equiv;
}

// Coupling invariant: comprimento e conteúdo equivalente
definition couplingInv() returns bool =
    a.names.length == ao.names.length;

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;
    require couplingInv();
    
    // Verificar equivalência de conteúdo antes
    uint256 lengthBefore = a.names.length;
    require lengthBefore < 10 => checkArrayEquivalence(lengthBefore);
    
    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;
    
    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;
    
    assert a_reverted == ao_reverted;
    assert couplingInv();
    
    // Verificar equivalência de conteúdo depois
    uint256 lengthAfter = a.names.length;
    assert lengthAfter < 10 => checkArrayEquivalence(lengthAfter);
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
    env e;
    address user;
    calldataarg args;
    
    require couplingInv();
    
    a.setUserName@withrevert(e, user, args);
    bool a_reverted = lastReverted;
    
    ao.setUserName@withrevert(e, user, args);
    bool ao_reverted = lastReverted;
    
    assert a_reverted == ao_reverted;
    
    // Verificar que os valores armazenados são equivalentes
    if (!a_reverted) {
        string storedA = a.getUserName(user);
        bytes storedAo = ao.getUserName(user);
        assert keccak256(storedA) == keccak256(storedAo);
    }
}

rule gasOptimizedCorrectnessOfGetUserName(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserName(address).selector,
    g -> g.selector == sig:ao.getUserName(address).selector
} {
    address user;
    
    string nameA = a.getUserName(user);
    bytes nameAo = ao.getUserName(user);
    
    // Verificar equivalência via keccak
    assert keccak256(nameA) == keccak256(nameAo);
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