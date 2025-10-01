using A as a;
using Ao as ao;


methods {
    // RewardsDistributor methods
    function getUserAccruedRewards(address, address) external returns (uint256) envfree => a.rewardsDistributor.getUserAccruedRewards(calldataarg);
    function getUserAccruedRewards(address, address) external returns (uint256) envfree => ao.rewardsDistributorOptimized.getUserAccruedRewards(calldataarg);
    
    function getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree => a.rewardsDistributor.getAllUserRewards(calldataarg);
    function getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree => ao.rewardsDistributorOptimized.getAllUserRewards(calldataarg);
    
    function getRewardsList() external returns (address[]) envfree => a.rewardsDistributor.getRewardsList();
    function getRewardsList() external returns (address[]) envfree => ao.rewardsDistributorOptimized.getRewardsList();
    
    function getUserAssetIndex(address, address, address) external returns (uint256) envfree => a.rewardsDistributor.getUserAssetIndex(calldataarg);
    function getUserAssetIndex(address, address, address) external returns (uint256) envfree => ao.rewardsDistributorOptimized.getUserAssetIndex(calldataarg);
}

definition couplingInv() returns bool =
    // RewardsDistributor invariant - comparação direta das variáveis internas
    _rewardsList_a.length == _rewardsList_ao.length &&
    _assetsList_a.length == _assetsList_ao.length &&
    // Todos os rewards devem estar igualmente habilitados
    (forall address reward. 
        _isRewardEnabled_a[reward] == _isRewardEnabled_ao[reward]) &&
    // Todos os assets devem ter os mesmos dados
    (forall address asset.
        _assets_a[asset].decimals == _assets_ao[asset].decimals &&
        _assets_a[asset].availableRewardsCount == _assets_ao[asset].availableRewardsCount) &&
    // Todos os rewards data devem ser idênticos
    (forall address asset. forall address reward.
        _assets_a[asset].rewards[reward].index == _assets_ao[asset].rewards[reward].index &&
        _assets_a[asset].rewards[reward].emissionPerSecond == _assets_ao[asset].rewards[reward].emissionPerSecond &&
        _assets_a[asset].rewards[reward].lastUpdateTimestamp == _assets_ao[asset].rewards[reward].lastUpdateTimestamp &&
        _assets_a[asset].rewards[reward].distributionEnd == _assets_ao[asset].rewards[reward].distributionEnd )&&
    // User data deve ser idêntico
    (forall address asset. forall address reward. forall address user.
        _assets_a[asset].rewards[reward].usersData[user].index == _assets_ao[asset].rewards[reward].usersData[user].index &&
        _assets_a[asset].rewards[reward].usersData[user].accrued == _assets_ao[asset].rewards[reward].usersData[user].accrued);
    
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfGetUserAccruedRewards
filtered {
    f -> f.selector == sig:a.getUserAccruedRewards(address, address).selector,
    g -> g.selector == sig:ao.getUserAccruedRewards(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for RewardsDistributor.getAllUserRewards
rule gasOptimizedCorrectnessOfGetAllUserRewards
filtered {
    f -> f.selector == sig:a.getAllUserRewards(address[], address).selector,
    g -> g.selector == sig:ao.getAllUserRewards(address[], address).selector
} {
    gasOptimizationCorrectness(f, g);
}