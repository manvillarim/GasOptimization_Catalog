using A as a;
using Ao as ao;

methods {

    function a.getAuthorized(address) external returns (bool) envfree;
    function ao.getAuthorized(address) external returns (bool) envfree;
    
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
    function a.paused() external returns (bool) envfree;
    function ao.paused() external returns (bool) envfree;
    function a.total() external returns (uint) envfree;
    function ao.total() external returns (uint) envfree;
    function a.count() external returns (uint) envfree;
    function ao.count() external returns (uint) envfree;
    function a.getNumbersLength() external returns (uint) envfree;
    function ao.getNumbersLength() external returns (uint) envfree;
    function a.numbers(uint256) external returns (uint256) envfree;
    function ao.numbers(uint256) external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.owner == ao.owner &&
    a.paused == ao.paused &&
    a.total == ao.total &&
    a.count == ao.count &&
    a.numbers.length == ao.numbers.length &&
    (
        a.numbers.length == 0 ||
        (forall uint256 i. (i < a.numbers.length => a.numbers[i] == ao.numbers[i]))
    ) &&

    (forall address addr. (a.authorized[addr] == ao.authorized[addr]));

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

rule gasOptimizedCorrectnessOfCriticalFunction(method f, method g)
filtered {
    f -> f.selector == sig:a.criticalFunction(address).selector,
    g -> g.selector == sig:ao.criticalFunction(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAuthorize(method f, method g)
filtered {
    f -> f.selector == sig:a.authorize(address).selector,
    g -> g.selector == sig:ao.authorize(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUnauthorize(method f, method g)
filtered {
    f -> f.selector == sig:a.unauthorize(address).selector,
    g -> g.selector == sig:ao.unauthorize(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetPaused(method f, method g)
filtered {
    f -> f.selector == sig:a.setPaused(bool).selector,
    g -> g.selector == sig:ao.setPaused(bool).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g)
filtered {
    f -> f.selector == sig:a.processNumbers(uint).selector,
    g -> g.selector == sig:ao.processNumbers(uint).selector
} {
    gasOptimizationCorrectness(f, g);
}