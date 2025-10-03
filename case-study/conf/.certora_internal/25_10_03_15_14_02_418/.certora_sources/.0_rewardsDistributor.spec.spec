using rewardsDistributorOriginal as a;
using rewardsDistributorOptimized as ao;

methods {
    function a.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function ao.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function a.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
    function ao.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
}

definition couplingInv() returns bool =
    a._rewardsList.length == ao._rewardsList.length &&
    a._assetsList.length == ao._assetsList.length &&
    
    (forall address asset. forall address reward. forall address user.
        a._assets[asset].rewards[reward].usersData[user].accrued == 
        ao._assets[asset].rewards[reward].usersData[user].accrued &&
        
        a._assets[asset].rewards[reward].usersData[user].index == 
        ao._assets[asset].rewards[reward].usersData[user].index
    ) &&
    
    (forall address asset. forall address reward.
        a._assets[asset].rewards[reward].index == 
        ao._assets[asset].rewards[reward].index &&
        
        a._assets[asset].rewards[reward].emissionPerSecond == 
        ao._assets[asset].rewards[reward].emissionPerSecond &&
        
        a._assets[asset].rewards[reward].lastUpdateTimestamp == 
        ao._assets[asset].rewards[reward].lastUpdateTimestamp &&
        
        a._assets[asset].rewards[reward].distributionEnd == 
        ao._assets[asset].rewards[reward].distributionEnd
    ) &&
    
    (forall address asset.
        a._assets[asset].decimals == ao._assets[asset].decimals &&
        a._assets[asset].availableRewardsCount == ao._assets[asset].availableRewardsCount
    ) &&
    
    (forall address reward.
        a._isRewardEnabled[reward] == ao._isRewardEnabled[reward]
    ) &&
    
    (forall uint256 i. 
        i < a._rewardsList.length => a._rewardsList[i] == ao._rewardsList[i]
    ) &&
    
    (forall uint256 i. 
        i < a._assetsList.length => a._assetsList[i] == ao._assetsList[i]
    );


function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}


rule gasOptimizedCorrectnessOfGetUserAccruedRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserAccruedRewards(address, address).selector,
    g -> g.selector == sig:ao.getUserAccruedRewards(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAllUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getAllUserRewards(address[], address).selector,
    g -> g.selector == sig:ao.getAllUserRewards(address[], address).selector
} {
    gasOptimizationCorrectness(f, g);
}