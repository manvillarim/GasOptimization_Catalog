using A as a;
using Ao as ao;

methods {
}

ghost mapping(uint256 => bytes32) ghostNamesA;
ghost mapping(address => bytes32) ghostUserNamesA;

hook Sstore a.names[INDEX uint256 index] string value {
    havoc ghostNamesA assuming ghostNamesA@new[index] == to_bytes32(value);
}

hook Sstore a.userNames[KEY address user] string value {
    havoc ghostUserNamesA assuming ghostUserNamesA@new[user] == to_bytes32(value);
}

definition couplingInv() returns bool =
    a.names.length == ao.names.length &&
    (forall address user. ghostUserNamesA[user] == ao.userNames[user]) &&
    (forall uint256 i. (i < a.names.length => ghostNamesA[i] == ao.names[i]));

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
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
    g -> g.selector == sig:ao.addName(bytes32).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetUserName(method f, method g)
filtered {
    f -> f.selector == sig:a.setUserName(address, string).selector,
    g -> g.selector == sig:ao.setUserName(address, bytes32).selector
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
    g -> g.selector == sig:ao.compareNames(bytes32, bytes32).selector
} {
    gasOptimizationCorrectness(f, g);
}