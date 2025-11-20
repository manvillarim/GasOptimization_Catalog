using A as a;
using Ao as ao;

methods {
    function a.setName(string) external envfree;
    function ao.setName(bytes) external envfree;
    function a.getName() external returns (string) envfree;
    function ao.getName() external returns (bytes) envfree;
    function a.compareName(string) external returns (bool) envfree;
    function ao.compareName(bytes) external returns (bool) envfree;
    function a.getNameHash() external returns (bytes32) envfree;
    function ao.getNameHash() external returns (bytes32) envfree;
}

definition couplingInv() returns bool =
    a.getNameHash() == ao.getNameHash();

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

rule gasOptimizedCorrectnessOfGetName(method f, method g)
filtered {
    f -> f.selector == sig:a.getName().selector,
    g -> g.selector == sig:ao.getName().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCompareName(method f, method g)
filtered {
    f -> f.selector == sig:a.compareName(string).selector,
    g -> g.selector == sig:ao.compareName(bytes).selector
} {
    gasOptimizationCorrectness(f, g);
}