using RewardsDistributorOriginal as a;
using RewardsDistributorOptimized as ao;

methods {
    function a.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function ao.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    
    function a.getAllUserRewards(address[], address) external returns (address[], uint256[]);
    function ao.getAllUserRewards(address[], address) external returns (address[], uint256[]);
    
    function a.getUserRewards(address[], address, address) external returns (uint256);
    function ao.getUserRewards(address[], address, address) external returns (uint256);
    
    function a.getRewardsData(address, address) external returns (uint256, uint256, uint256, uint256) envfree;
    function ao.getRewardsData(address, address) external returns (uint256, uint256, uint256, uint256) envfree;
    
    function a.getAssetIndex(address, address) external returns (uint256, uint256);
    function ao.getAssetIndex(address, address) external returns (uint256, uint256);
    
    function a.getDistributionEnd(address, address) external returns (uint256) envfree;
    function ao.getDistributionEnd(address, address) external returns (uint256) envfree;
    
    function a.getRewardsByAsset(address) external returns (address[]) envfree;
    function ao.getRewardsByAsset(address) external returns (address[]) envfree;
    
    function a.getRewardsList() external returns (address[]) envfree;
    function ao.getRewardsList() external returns (address[]) envfree;
    
    function a.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
    function ao.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
    
    function a.getAssetDecimals(address) external returns (uint8) envfree;
    function ao.getAssetDecimals(address) external returns (uint8) envfree;
    
    function a.getEmissionManager() external returns (address) envfree;
    function ao.getEmissionManager() external returns (address) envfree;
    
    function a.setDistributionEnd(address, address, uint32) external;
    function ao.setDistributionEnd(address, address, uint32) external;
    
    function a.setEmissionPerSecond(address, address[], uint88[]) external;
    function ao.setEmissionPerSecond(address, address[], uint88[]) external;
}


definition couplingInv() returns bool =

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
    );


function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
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

rule gasOptimizedCorrectnessOfGetUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserRewards(address[], address, address).selector,
    g -> g.selector == sig:ao.getUserRewards(address[], address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetRewardsData(method f, method g)
filtered {
    f -> f.selector == sig:a.getRewardsData(address, address).selector,
    g -> g.selector == sig:ao.getRewardsData(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAssetIndex(method f, method g)
filtered {
    f -> f.selector == sig:a.getAssetIndex(address, address).selector,
    g -> g.selector == sig:ao.getAssetIndex(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetDistributionEnd(method f, method g)
filtered {
    f -> f.selector == sig:a.getDistributionEnd(address, address).selector,
    g -> g.selector == sig:ao.getDistributionEnd(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetRewardsByAsset(method f, method g)
filtered {
    f -> f.selector == sig:a.getRewardsByAsset(address).selector,
    g -> g.selector == sig:ao.getRewardsByAsset(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetRewardsList(method f, method g)
filtered {
    f -> f.selector == sig:a.getRewardsList().selector,
    g -> g.selector == sig:ao.getRewardsList().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetUserAssetIndex(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserAssetIndex(address, address, address).selector,
    g -> g.selector == sig:ao.getUserAssetIndex(address, address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAssetDecimals(method f, method g)
filtered {
    f -> f.selector == sig:a.getAssetDecimals(address).selector,
    g -> g.selector == sig:ao.getAssetDecimals(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetEmissionManager(method f, method g)
filtered {
    f -> f.selector == sig:a.getEmissionManager().selector,
    g -> g.selector == sig:ao.getEmissionManager().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetDistributionEnd(method f, method g)
filtered {
    f -> f.selector == sig:a.setDistributionEnd(address, address, uint32).selector,
    g -> g.selector == sig:ao.setDistributionEnd(address, address, uint32).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetEmissionPerSecond(method f, method g)
filtered {
    f -> f.selector == sig:a.setEmissionPerSecond(address, address[], uint88[]).selector,
    g -> g.selector == sig:ao.setEmissionPerSecond(address, address[], uint88[]).selector
} {
    gasOptimizationCorrectness(f, g);
}