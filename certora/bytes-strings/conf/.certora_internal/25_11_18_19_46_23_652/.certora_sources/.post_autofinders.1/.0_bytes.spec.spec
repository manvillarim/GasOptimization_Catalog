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

// Ghost variables to track hashes
ghost mapping(uint256 => bytes32) ghostNamesHashA;
ghost mapping(uint256 => bytes32) ghostNamesHashAo;
ghost mapping(address => bytes32) ghostUserNamesHashA;
ghost mapping(address => bytes32) ghostUserNamesHashAo;

// Hooks to capture hash values when storing in A
hook Sstore a.names[INDEX uint256 index] string value {
    ghostNamesHashA[index] = keccak256(value);
}

hook Sstore a.userNames[KEY address user] string value {
    ghostUserNamesHashA[user] = keccak256(value);
}

// Hooks to capture hash values when storing in Ao
hook Sstore ao.names[INDEX uint256 index] bytes value {
    ghostNamesHashAo[index] = keccak256(value);
}

hook Sstore ao.userNames[KEY address user] bytes value {
    ghostUserNamesHashAo[user] = keccak256(value);
}

// Coupling invariant using ghost variables
definition couplingInv() returns bool =
    a.names.length == ao.names.length &&
    (forall uint256 i. (i < a.names.length) => 
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