using A as a;
using Ao as ao;

methods {
    function a.resetAllValues() external;
    function ao.resetAllValues() external;
}


definition couplingInv() returns bool =
    a.balance == ao.balance &&
    a.userCount == ao.userCount &&
    a.temperature == ao.temperature &&
    a.isActive == ao.isActive &&
    a.isPaused == ao.isPaused &&
    a.owner == ao.owner &&
    a.admin == ao.admin &&
    a.dataHash == ao.dataHash &&
    (forall address addr . a.balances[addr] == ao.balances[addr]);


function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}


rule gasOptimizedCorrectnessOfResetAllValues(method f, method g)
    filtered {
        f -> f.selector == sig:a.resetAllValues().selector,
        g -> g.selector == sig:ao.resetAllValues().selector
    } {
    gasOptimizationCorrectness(f, g);
}