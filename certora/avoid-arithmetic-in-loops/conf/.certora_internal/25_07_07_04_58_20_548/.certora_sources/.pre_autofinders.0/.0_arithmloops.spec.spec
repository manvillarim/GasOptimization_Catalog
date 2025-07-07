using A as a;
using Ao as ao;

methods {

}

definition couplingInv() returns bool =
    a.baseValue == ao.baseValue &&
    a.multiplier == ao.multiplier &&
    a.data.length == ao.data.length &&
    (
        a.data.length == 0 ||
        (forall uint256 i. (i < a.data.length => a.data[i] == ao.data[i]))
    );

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfProcessData(method f, method g)
    filtered {
        f -> f.selector == sig:a.processData().selector,
        g -> g.selector == sig:ao.processData().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateTotals_Return {
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();

    uint totalA = a.calculateTotals(eA, args);
    uint totalAo = ao.calculateTotals(eAo, args);

    assert totalA == totalAo;
    assert couplingInv();
}