using A as a;
using Ao as ao;

methods {
    function a.addName(string) external envfree;
    function ao.addName(bytes) external envfree;
    function a.setUserName(address, string) external envfree;
    function ao.setUserName(address, bytes) external envfree;
}

ghost mapping(uint256 => bytes32) ghostNamesHashA {
    init_state axiom forall uint256 i. ghostNamesHashA[i] == to_bytes32(0);
}

ghost mapping(uint256 => bytes32) ghostNamesHashAo {
    init_state axiom forall uint256 i. ghostNamesHashAo[i] == to_bytes32(0);
}

ghost mapping(address => bytes32) ghostUserNamesHashA {
    init_state axiom forall address u. ghostUserNamesHashA[u] == to_bytes32(0);
}

ghost mapping(address => bytes32) ghostUserNamesHashAo {
    init_state axiom forall address u. ghostUserNamesHashAo[u] == to_bytes32(0);
}

hook Sstore a.names[INDEX uint256 index] string newValue  {
    ghostNamesHashA[index] = keccak256(newValue);
}

hook Sstore ao.names[INDEX uint256 index] bytes newValue  {
    ghostNamesHashAo[index] = keccak256(newValue);
}

hook Sstore a.userNames[KEY address user] string newValue {
    ghostUserNamesHashA[user] = keccak256(newValue);
}

hook Sstore ao.userNames[KEY address user] bytes newValue {
    ghostUserNamesHashAo[user] = keccak256(newValue);
}

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