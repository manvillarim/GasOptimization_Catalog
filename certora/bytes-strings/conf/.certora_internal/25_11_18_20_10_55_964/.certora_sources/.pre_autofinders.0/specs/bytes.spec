using A as a;
using Ao as ao;

methods {
    function a.addName(string) external envfree;
    function ao.addName(bytes) external envfree;
    function a.setUserName(address, string) external envfree;
    function ao.setUserName(address, bytes) external envfree;
    function a.getUserName(address) external returns (string) envfree;
    function ao.getUserName(address) external returns (bytes) envfree;
    function a.getNameAt(uint256) external returns (string) envfree;
    function ao.getNameAt(uint256) external returns (bytes) envfree;
    function a.compareNames(string, string) external returns (bool) envfree;
    function ao.compareNames(bytes, bytes) external returns (bool) envfree;
    function a.getNameHashAt(uint256) external returns (bytes32) envfree;
    function ao.getNameHashAt(uint256) external returns (bytes32) envfree;
    function a.getUserNameHash(address) external returns (bytes32) envfree;
    function ao.getUserNameHash(address) external returns (bytes32) envfree;
    function a.getNamesLength() external returns (uint256) envfree;
    function ao.getNamesLength() external returns (uint256) envfree;
}

// Ghosts para rastrear os hashes
ghost mapping(uint256 => bytes32) ghostNamesHashA;
ghost mapping(uint256 => bytes32) ghostNamesHashAo;
ghost mapping(address => bytes32) ghostUserNamesHashA;
ghost mapping(address => bytes32) ghostUserNamesHashAo;
ghost uint256 ghostNamesLengthA;
ghost uint256 ghostNamesLengthAo;

// Hooks para manter os ghosts sincronizados com o contrato A
hook Sstore a.names[INDEX uint256 index] string value {
    ghostNamesHashA[index] = a.getNameHashAt(index);
}

hook Sstore a.userNames[KEY address user] string value {
    ghostUserNamesHashA[user] = a.getUserNameHash(user);
}

hook Sstore a.names.(offset 0) uint256 length {
    ghostNamesLengthA = length;
}

// Hooks para manter os ghosts sincronizados com o contrato Ao
hook Sstore ao.names[INDEX uint256 index] bytes value {
    ghostNamesHashAo[index] = ao.getNameHashAt(index);
}

hook Sstore ao.userNames[KEY address user] bytes value {
    ghostUserNamesHashAo[user] = ao.getUserNameHash(user);
}

hook Sstore ao.names.(offset 0) uint256 length {
    ghostNamesLengthAo = length;
}

// Invariante de acoplamento usando ghosts
definition couplingInv() returns bool =
    ghostNamesLengthA == ghostNamesLengthAo &&
    (forall uint256 i. (i < ghostNamesLengthA) => 
        ghostNamesHashA[i] == ghostNamesHashAo[i]) &&
    (forall address user. 
        ghostUserNamesHashA[user] == ghostUserNamesHashAo[user]);

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