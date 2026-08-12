using A as a;
using Ao as ao;

methods {
    function a.orderCount() external returns (uint256) envfree;
    function ao.orderCount() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.orderCount == ao.orderCount &&
    (forall uint256 id. (
        a.orders[id].quantity == ao.orders[id].quantity &&
        a.orders[id].amount == ao.orders[id].amount &&
        a.orders[id].price == ao.orders[id].price
    ));

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

rule gasOptimizedCorrectnessOfCreateOrder(method f, method g)
    filtered {
        f -> f.selector == sig:a.createOrder(uint128, uint256, uint128).selector,
        g -> g.selector == sig:ao.createOrder(uint128, uint256, uint128).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUpdateAmount(method f, method g)
    filtered {
        f -> f.selector == sig:a.updateAmount(uint256, uint256).selector,
        g -> g.selector == sig:ao.updateAmount(uint256, uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUpdateNarrow(method f, method g)
    filtered {
        f -> f.selector == sig:a.updateNarrow(uint256, uint128, uint128).selector,
        g -> g.selector == sig:ao.updateNarrow(uint256, uint128, uint128).selector
    } {
    gasOptimizationCorrectness(f, g);
}
