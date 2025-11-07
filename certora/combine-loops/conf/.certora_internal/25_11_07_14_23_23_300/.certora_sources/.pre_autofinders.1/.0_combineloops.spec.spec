using A as a;
using Ao as ao;

methods {

}

definition couplingInv() returns bool =
    a.sum == ao.sum &&
    a.product == ao.product &&
    a.count == ao.count &&
    a.numbers.length == ao.numbers.length &&
    (
        a.numbers.length == 0 ||
        (forall uint256 i. (i < a.numbers.length => a.numbers[i] == ao.numbers[i]))
    );

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

rule gasOptimizedCorrectnessOfProcessArray(method f, method g)
    filtered {
        f -> f.selector == sig:a.processArray().selector,
        g -> g.selector == sig:ao.processArray().selector
    } {
    gasOptimizationCorrectness(f, g);
}