using A as a;
using Ao as ao;

methods {
    function a.total() external returns (uint256) envfree;
    function ao.total() external returns (uint256) envfree;

    function a.lastScale() external returns (uint256) envfree;
    function ao.lastScale() external returns (uint256) envfree;

    function a.lastPackWho() external returns (address) envfree;
    function ao.lastPackWho() external returns (address) envfree;

    function a.lastPackAmount() external returns (uint256) envfree;
    function ao.lastPackAmount() external returns (uint256) envfree;

    function a.lastPackActive() external returns (bool) envfree;
    function ao.lastPackActive() external returns (bool) envfree;

    function a.lastAccumulate() external returns (uint256) envfree;
    function ao.lastAccumulate() external returns (uint256) envfree;

    function a.lastClassify() external returns (uint256) envfree;
    function ao.lastClassify() external returns (uint256) envfree;

    function a.lastGuard() external returns (uint256) envfree;
    function ao.lastGuard() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.total == ao.total &&
    (forall uint256 id. a.values[id] == ao.values[id]) &&
    (forall uint256 id. a.owners[id] == ao.owners[id]) &&
    a.lastScale == ao.lastScale &&
    a.lastPackWho == ao.lastPackWho &&
    a.lastPackAmount == ao.lastPackAmount &&
    a.lastPackActive == ao.lastPackActive &&
    a.lastAccumulate == ao.lastAccumulate &&
    a.lastClassify == ao.lastClassify &&
    a.lastGuard == ao.lastGuard;

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

rule gasOptimizedCorrectnessOfScale(method f, method g)
filtered {
    f -> f.selector == sig:a.scale_instr(uint256, uint256).selector,
    g -> g.selector == sig:ao.scale_instr(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfPack(method f, method g)
filtered {
    f -> f.selector == sig:a.pack_instr(uint256).selector,
    g -> g.selector == sig:ao.pack_instr(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAccumulate(method f, method g)
filtered {
    f -> f.selector == sig:a.accumulate_instr(uint256, uint256).selector,
    g -> g.selector == sig:ao.accumulate_instr(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfClassify(method f, method g)
filtered {
    f -> f.selector == sig:a.classify_instr(uint256).selector,
    g -> g.selector == sig:ao.classify_instr(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGuard(method f, method g)
filtered {
    f -> f.selector == sig:a.guard_instr(uint256).selector,
    g -> g.selector == sig:ao.guard_instr(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}
