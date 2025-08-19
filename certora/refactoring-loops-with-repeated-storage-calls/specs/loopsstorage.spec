// SPDX-License-Identifier: MIT
using A as a;
using Ao as ao;

methods {
    function calculateTotal() external;
    function complexCalculation() external;
    function nestedCalculation() external;
    function conditionalAccumulation(uint256) external;
    function distributeRewards(uint256) external;
    function calculateWeightedSum() external;
    function incrementalProduct() external;
    function multiStorageOperation() external;
    function addValue(uint256) external;
    function addWeight(uint256) external;
    function addUser(address, uint256) external;
    function resetTotals() external;
}

definition couplingInvariant() returns bool = a.total == ao.total && a.accumulator == ao.accumulator && a.counter == ao.counter && a.sumOfSquares == ao.sumOfSquares && a.productTotal == ao.productTotal && a.weightedSum == ao.weightedSum && a.globalMultiplier == ao.globalMultiplier && a.globalDivisor == ao.globalDivisor && a.bonusThreshold == ao.bonusThreshold && a.values.length == ao.values.length && (forall uint256 i. (i < a.values.length => a.values[i] == ao.values[i])) && a.weights.length == ao.weights.length && (forall uint256 i. (i < a.weights.length => a.weights[i] == ao.weights[i])) && a.users.length == ao.users.length && (forall uint256 i. (i < a.users.length => a.users[i] == ao.users[i] && a.userBalances[a.users[i]] == ao.userBalances[ao.users[i]]));

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && couplingInvariant();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInvariant();
}

rule gasOptimizedCorrectnessOfCalculateTotal(method f, method g)
filtered { f -> f.selector == sig:a.calculateTotal().selector, g -> g.selector == sig:ao.calculateTotal().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfComplexCalculation(method f, method g)
filtered { f -> f.selector == sig:a.complexCalculation().selector, g -> g.selector == sig:ao.complexCalculation().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfNestedCalculation(method f, method g)
filtered { f -> f.selector == sig:a.nestedCalculation().selector, g -> g.selector == sig:ao.nestedCalculation().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfConditionalAccumulation(method f, method g)
filtered { f -> f.selector == sig:a.conditionalAccumulation(uint256).selector, g -> g.selector == sig:ao.conditionalAccumulation(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDistributeRewards(method f, method g)
filtered { f -> f.selector == sig:a.distributeRewards(uint256).selector, g -> g.selector == sig:ao.distributeRewards(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateWeightedSum(method f, method g)
filtered { f -> f.selector == sig:a.calculateWeightedSum().selector, g -> g.selector == sig:ao.calculateWeightedSum().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfIncrementalProduct(method f, method g)
filtered { f -> f.selector == sig:a.incrementalProduct().selector, g -> g.selector == sig:ao.incrementalProduct().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfMultiStorageOperation(method f, method g)
filtered { f -> f.selector == sig:a.multiStorageOperation().selector, g -> g.selector == sig:ao.multiStorageOperation().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAddValue(method f, method g)
filtered { f -> f.selector == sig:a.addValue(uint256).selector, g -> g.selector == sig:ao.addValue(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAddWeight(method f, method g)
filtered { f -> f.selector == sig:a.addWeight(uint256).selector, g -> g.selector == sig:ao.addWeight(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAddUser(method f, method g)
filtered { f -> f.selector == sig:a.addUser(address, uint256).selector, g -> g.selector == sig:ao.addUser(address, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfResetTotals(method f, method g)
filtered { f -> f.selector == sig:a.resetTotals().selector, g -> g.selector == sig:ao.resetTotals().selector } {
    gasOptimizationCorrectness(f, g);
}

