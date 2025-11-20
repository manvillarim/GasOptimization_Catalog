methods {

    function a.getValue() external returns (uint256) envfree;
    
    function ao.getValue() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.owner == ao.owner &&
    a.value == ao.value &&
    a.name == ao.name;

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

rule gasOptimizedCorrectnessOf_getValue(method f, method g)
filtered {
    f -> f.selector == sig:a.getValue().selector,
    g -> g.selector == sig:ao.getValue().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOf_incrementCounter(method f, method g)
filtered {
    f -> f.selector == sig:a.incrementCounter().selector,
    g -> g.selector == sig:ao.incrementCounter().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOf_setValue(method f, method g)
filtered {
    f -> f.selector == sig:a.setValue(uint256).selector,
    g -> g.selector == sig:ao.setValue(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOf_setOwner(method f, method g)
filtered {
    f -> f.selector == sig:a.setOwner(address).selector,
    g -> g.selector == sig:ao.setOwner(address).selector
} {
    gasOptimizationCorrectness(f, g);
}
