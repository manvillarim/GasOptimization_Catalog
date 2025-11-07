using A as a;
using Ao as ao;

methods {
    function sumTokensWithConstantCheck() external;
    function processRewardsWithChecks() external;
    function updateBalancesWithStateCheck() external;
    function addTokens(uint256[] memory) external;
    function addBalances(uint256[] memory) external;
    function addRewards(uint256[] memory) external;
    function complexConstantComparison() external returns (uint256);
    function processWithBaseAmountCheck() external returns (uint256);
    function nestedLoopWithConstantCheck(uint256, uint256) external returns (uint256);
    function logicalConstantComparison() external returns (uint256);
    function mathematicalConstantCheck() external returns (uint256);
}

definition couplingInvariant() returns bool = 
a.total == ao.total && 
a.rewardSum == ao.rewardSum &&
a.balanceSum == ao.balanceSum &&
a.isActive == ao.isActive && 
a.baseAmount == ao.baseAmount && 
a.tokens.length == ao.tokens.length && 
(forall uint256 i. (i < a.tokens.length => a.tokens[i] == ao.tokens[i])) && 
a.balances.length == ao.balances.length && 
(forall uint256 i. (i < a.balances.length => a.balances[i] == ao.balances[i])) && 
a.rewards.length == ao.rewards.length && 
(forall uint256 i. (i < a.rewards.length => a.rewards[i] == ao.rewards[i]));

function stateOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && couplingInvariant();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInvariant();
}

rule optimizedCorrectnessOfSumTokensWithConstantCheck(method f, method g)
filtered { f -> f.selector == sig:a.sumTokensWithConstantCheck().selector, g -> g.selector == sig:ao.sumTokensWithConstantCheck().selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfProcessRewardsWithChecks(method f, method g)
filtered { f -> f.selector == sig:a.processRewardsWithChecks().selector, g -> g.selector == sig:ao.processRewardsWithChecks().selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfUpdateBalancesWithStateCheck(method f, method g)
filtered { f -> f.selector == sig:a.updateBalancesWithStateCheck().selector, g -> g.selector == sig:ao.updateBalancesWithStateCheck().selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfAddTokens(method f, method g)
filtered { f -> f.selector == sig:a.addTokens(uint256[]).selector, g -> g.selector == sig:ao.addTokens(uint256[]).selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfAddBalances(method f, method g)
filtered { f -> f.selector == sig:a.addBalances(uint256[]).selector, g -> g.selector == sig:ao.addBalances(uint256[]).selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfAddRewards(method f, method g)
filtered { f -> f.selector == sig:a.addRewards(uint256[]).selector, g -> g.selector == sig:ao.addRewards(uint256[]).selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfComplexConstantComparison(method f, method g)
filtered { f -> f.selector == sig:a.complexConstantComparison().selector, g -> g.selector == sig:ao.complexConstantComparison().selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfProcessWithBaseAmountCheck(method f, method g)
filtered { f -> f.selector == sig:a.processWithBaseAmountCheck().selector, g -> g.selector == sig:ao.processWithBaseAmountCheck().selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfNestedLoopWithConstantCheck(method f, method g)
filtered { f -> f.selector == sig:a.nestedLoopWithConstantCheck(uint256, uint256).selector, g -> g.selector == sig:ao.nestedLoopWithConstantCheck(uint256, uint256).selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfLogicalConstantComparison(method f, method g)
filtered { f -> f.selector == sig:a.logicalConstantComparison().selector, g -> g.selector == sig:ao.logicalConstantComparison().selector } {
    stateOptimizationCorrectness(f, g);
}

rule optimizedCorrectnessOfMathematicalConstantCheck(method f, method g)
filtered { f -> f.selector == sig:a.mathematicalConstantCheck().selector, g -> g.selector == sig:ao.mathematicalConstantCheck().selector } {
    stateOptimizationCorrectness(f, g);
}

