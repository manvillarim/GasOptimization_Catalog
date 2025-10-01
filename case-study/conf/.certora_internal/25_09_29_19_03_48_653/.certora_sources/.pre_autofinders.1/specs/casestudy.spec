using A as a;
using Ao as ao;

methods {
    // RewardsDistributor wrapper methods
    function a.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function ao.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    
    function a.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
    function ao.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
    
    function a.getRewardsList() external returns (address[]) envfree;
    function ao.getRewardsList() external returns (address[]) envfree;
    
    function a.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
    function ao.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
}

// Ghost variables para rastrear estado interno
ghost mapping(address => mapping(address => uint256)) ghostAccruedA;
ghost mapping(address => mapping(address => uint256)) ghostAccruedAo;
ghost uint256 ghostRewardsLengthA;
ghost uint256 ghostRewardsLengthAo;

// Hooks para atualizar ghost variables quando funções são chamadas
hook Sload uint256 v a._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].accrued {
    ghostAccruedA[user][reward] = v;
}

hook Sload uint256 v ao._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].accrued{
    ghostAccruedAo[user][reward] = v;
}

hook Sload uint256 v a._rewardsList.length {
    ghostRewardsLengthA = v;
}

hook Sload uint256 v ao._rewardsList.length  {
    ghostRewardsLengthAo = v;
}

definition couplingInv() returns bool =
    ghostRewardsLengthA == ghostRewardsLengthAo &&
    (forall address user. forall address reward. 
        ghostAccruedA[user][reward] == ghostAccruedAo[user][reward]);

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

// Rule for getUserAccruedRewards
rule gasOptimizedCorrectnessOfGetUserAccruedRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserAccruedRewards(address, address).selector,
    g -> g.selector == sig:ao.getUserAccruedRewards(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for getAllUserRewards
rule gasOptimizedCorrectnessOfGetAllUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getAllUserRewards(address[], address).selector,
    g -> g.selector == sig:ao.getAllUserRewards(address[], address).selector
} {
    gasOptimizationCorrectness(f, g);
}