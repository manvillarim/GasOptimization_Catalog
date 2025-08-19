// SPDX-License-Identifier: MIT
using A as a;
using Ao as ao;

methods {
    function a.initializeArrays(uint256 size) external;
    function a.distributeTokens() external;
    function a.calculateRewards() external;
    function a.applyPenalties(uint256 penaltyFactor) external;
    function a.updateTokensConditional(bool applyBonus) external;
    function a.processMatrix(uint256 rows, uint256 cols) external;
    function ao.initializeArrays(uint256 size) external;
    function ao.distributeTokens() external;
    function ao.calculateRewards() external;
    function ao.applyPenalties(uint256 penaltyFactor) external;
    function ao.updateTokensConditional(bool applyBonus) external;
    function ao.processMatrix(uint256 rows, uint256 cols) external;
}

definition couplingInvariant() returns bool = a.limit == ao.limit && a.price == ao.price && a.baseReward == ao.baseReward && a.multiplier == ao.multiplier && a.taxRate == ao.taxRate && a.totalSupply == ao.totalSupply && a.tokens.length == ao.tokens.length && (forall uint256 i. (i < a.tokens.length => a.tokens[i] == ao.tokens[i])) && a.rewards.length == ao.rewards.length && (forall uint256 i. (i < a.rewards.length => a.rewards[i] == ao.rewards[i])) && a.penalties.length == ao.penalties.length && (forall uint256 i. (i < a.penalties.length => a.penalties[i] == ao.penalties[i]));

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo;
    require couplingInvariant();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInvariant();
}

rule gasOptimizedCorrectnessOfInitializeArrays(method f, method g)
filtered { f -> f.selector == sig:a.initializeArrays(uint256).selector, g -> g.selector == sig:ao.initializeArrays(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDistributeTokens(method f, method g)
filtered { f -> f.selector == sig:a.distributeTokens().selector, g -> g.selector == sig:ao.distributeTokens().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateRewards(method f, method g)
filtered { f -> f.selector == sig:a.calculateRewards().selector, g -> g.selector == sig:ao.calculateRewards().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfApplyPenalties(method f, method g)
filtered { f -> f.selector == sig:a.applyPenalties(uint256).selector, g -> g.selector == sig:ao.applyPenalties(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUpdateTokensConditional(method f, method g)
filtered { f -> f.selector == sig:a.updateTokensConditional(bool).selector, g -> g.selector == sig:ao.updateTokensConditional(bool).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfProcessMatrix(method f, method g)
filtered { f -> f.selector == sig:a.processMatrix(uint256, uint256).selector, g -> g.selector == sig:ao.processMatrix(uint256, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

