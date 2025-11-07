using A as a;
using Ao as ao;

methods {

}

definition couplingInv() returns bool =
    a.totalSumOfProducts == ao.totalSumOfProducts &&
    a.array1.length == ao.array1.length &&
    a.array2.length == ao.array2.length &&
    (
        a.array1.length == 0 ||
        (forall uint256 i. (i < a.array1.length => a.array1[i] == ao.array1[i]))
    ) &&
    (
        a.array2.length == 0 ||
        (forall uint256 j. (j < a.array2.length => a.array2[j] == ao.array2[j]))
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

rule gasOptimizedCorrectnessOfCalculateSumOfProducts(method f, method g)
    filtered {
        f -> f.selector == sig:a.calculateSumOfProducts().selector,
        g -> g.selector == sig:ao.calculateSumOfProducts().selector
    } {
    gasOptimizationCorrectness(f, g);
}