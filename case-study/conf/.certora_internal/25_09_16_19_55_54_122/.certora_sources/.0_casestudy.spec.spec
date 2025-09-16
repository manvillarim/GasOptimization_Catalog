using CentralUnit as aao;

methods {
    // SupplyLogic methods accessed through CentralUnit
    function executeWithdrawOriginal(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams) external returns (uint256) => aao.supplyLogic.executeWithdraw(calldataarg);
    function executeWithdrawOptimized(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams) external returns (uint256) => aao.supplyLogicOptimized.executeWithdraw(calldataarg);
    
    // BorrowLogic methods accessed through CentralUnit
    function executeBorrowOriginal(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams) external => aao.borrowLogic.executeBorrow(calldataarg);
    function executeBorrowOptimized(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams) external => aao.borrowLogicOptimized.executeBorrow(calldataarg);
    
    function executeRepayOriginal(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams) external returns (uint256) => aao.borrowLogic.executeRepay(calldataarg);
    function executeRepayOptimized(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams) external returns (uint256) => aao.borrowLogicOptimized.executeRepay(calldataarg);
    
    // ReserveLogic methods accessed through CentralUnit
    function cumulateToLiquidityIndexOriginal(DataTypes.ReserveData, uint256, uint256) external returns (uint256) => aao.reserveLogic.cumulateToLiquidityIndex(calldataarg);
    function cumulateToLiquidityIndexOptimized(DataTypes.ReserveData, uint256, uint256) external returns (uint256) => aao.reserveLogicOptimized.cumulateToLiquidityIndex(calldataarg);
    
    function cacheOriginal(DataTypes.ReserveData) external returns (DataTypes.ReserveCache) => aao.reserveLogic.cache(calldataarg);
    function cacheOptimized(DataTypes.ReserveData) external returns (DataTypes.ReserveCache) => aao.reserveLogicOptimized.cache(calldataarg);
    
    // UserConfiguration methods accessed through CentralUnit
    function setUsingAsCollateralOriginal(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfiguration.setUsingAsCollateral(calldataarg);
    function setUsingAsCollateralOptimized(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfigurationOptimized.setUsingAsCollateral(calldataarg);
    
    function setBorrowingOriginal(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfiguration.setBorrowing(calldataarg);
    function setBorrowingOptimized(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfigurationOptimized.setBorrowing(calldataarg);
    
    function isUsingAsCollateralOriginal(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfiguration.isUsingAsCollateral(calldataarg);
    function isUsingAsCollateralOptimized(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfigurationOptimized.isUsingAsCollateral(calldataarg);
    
    function isBorrowingOriginal(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfiguration.isBorrowing(calldataarg);
    function isBorrowingOptimized(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfigurationOptimized.isBorrowing(calldataarg);
    
    // RewardsDistributor methods accessed through CentralUnit
    function setEmissionPerSecondOriginal(address, address[], uint88[]) external => aao.rewardsDistributor.setEmissionPerSecond(calldataarg);
    function setEmissionPerSecondOptimized(address, address[], uint88[]) external => aao.rewardsDistributorOptimized.setEmissionPerSecond(calldataarg);
    
    function configureAssetsOriginal(RewardsDataTypes.RewardsConfigInput[]) internal => aao.rewardsDistributor._configureAssets(calldataarg);
    function configureAssetsOptimized(RewardsDataTypes.RewardsConfigInput[]) internal => aao.rewardsDistributorOptimized._configureAssets(calldataarg);
    
    function getDistributionEndOriginal(address, address) external returns (uint256) envfree => aao.rewardsDistributor.getDistributionEnd(calldataarg);
    function getDistributionEndOptimized(address, address) external returns (uint256) envfree => aao.rewardsDistributorOptimized.getDistributionEnd(calldataarg);
    
    function getRewardsByAssetOriginal(address) external returns (address[]) envfree => aao.rewardsDistributor.getRewardsByAsset(calldataarg);
    function getRewardsByAssetOptimized(address) external returns (address[]) envfree => aao.rewardsDistributorOptimized.getRewardsByAsset(calldataarg);
    
    // Collector methods accessed through CentralUnit
    function createStreamOriginal(address, uint256, address, uint256, uint256) external returns (uint256) => aao.collector.createStream(calldataarg);
    function createStreamOptimized(address, uint256, address, uint256, uint256) external returns (uint256) => aao.collectorOptimized.createStream(calldataarg);
    
    function deltaOfOriginal(uint256) external returns (uint256) => aao.collector.deltaOf(calldataarg);
    function deltaOfOptimized(uint256) external returns (uint256) => aao.collectorOptimized.deltaOf(calldataarg);
    
    function withdrawFromStreamOriginal(uint256, uint256) external returns (bool) => aao.collector.withdrawFromStream(calldataarg);
    function withdrawFromStreamOptimized(uint256, uint256) external returns (bool) => aao.collectorOptimized.withdrawFromStream(calldataarg);
    
    function cancelStreamOriginal(uint256) external returns (bool) => aao.collector.cancelStream(calldataarg);
    function cancelStreamOptimized(uint256) external returns (bool) => aao.collectorOptimized.cancelStream(calldataarg);
    
    function getNextStreamIdOriginal() external returns (uint256) envfree => aao.collector.getNextStreamId();
    function getNextStreamIdOptimized() external returns (uint256) envfree => aao.collectorOptimized.getNextStreamId();
    
    function getStreamOriginal(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree => aao.collector.getStream(calldataarg);
    function getStreamOptimized(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree => aao.collectorOptimized.getStream(calldataarg);
}

// Ghost variables para estado interno
ghost mapping(address => mapping(uint256 => bool)) userConfigCollateral_original;
ghost mapping(address => mapping(uint256 => bool)) userConfigCollateral_optimized;
ghost mapping(address => mapping(uint256 => bool)) userConfigBorrowing_original;
ghost mapping(address => mapping(uint256 => bool)) userConfigBorrowing_optimized;
ghost uint128 liquidityIndex_original;
ghost uint128 liquidityIndex_optimized;
ghost uint128 variableBorrowIndex_original;
ghost uint128 variableBorrowIndex_optimized;
ghost mapping(address => mapping(address => uint256)) rewardDistributionEnd_original;
ghost mapping(address => mapping(address => uint256)) rewardDistributionEnd_optimized;
ghost mapping(address => mapping(address => uint88)) rewardEmissionPerSecond_original;
ghost mapping(address => mapping(address => uint88)) rewardEmissionPerSecond_optimized;

definition couplingInv() returns bool =
    // UserConfiguration state
    (forall address user. forall uint256 reserveId.
        userConfigCollateral_original[user][reserveId] == userConfigCollateral_optimized[user][reserveId] &&
        userConfigBorrowing_original[user][reserveId] == userConfigBorrowing_optimized[user][reserveId]
    ) &&
    
    // ReserveLogic state
    liquidityIndex_original == liquidityIndex_optimized &&
    variableBorrowIndex_original == variableBorrowIndex_optimized &&
    
    // RewardsDistributor state
    (forall address asset. forall address reward.
        getDistributionEndOriginal(asset, reward) == getDistributionEndOptimized(asset, reward) &&
        rewardDistributionEnd_original[asset][reward] == rewardDistributionEnd_optimized[asset][reward] &&
        rewardEmissionPerSecond_original[asset][reward] == rewardEmissionPerSecond_optimized[asset][reward]
    ) &&
    
    // Collector state
    getNextStreamIdOriginal() == getNextStreamIdOptimized() &&
    (forall uint256 streamId.
        getStreamOriginal(streamId) == getStreamOptimized(streamId)
    );

function gasOptimizationCorrectness(method f, method g) {
    env eOriginal;
    env eOptimized;
    calldataarg args;
    
    require eOriginal.msg.sender == eOptimized.msg.sender;
    require eOriginal.block.timestamp == eOptimized.block.timestamp;
    require eOriginal.block.number == eOptimized.block.number;
    require couplingInv();
    
    f@withrevert(eOriginal, args);
    bool revertedOriginal = lastReverted;
    
    g@withrevert(eOptimized, args);
    bool revertedOptimized = lastReverted;
    
    assert revertedOriginal == revertedOptimized;
    assert !revertedOriginal => couplingInv();
}

rule gasOptimizedCorrectnessOfExecuteWithdraw(method f, method g)
filtered {
    f -> f.selector == sig:executeWithdrawOriginal(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams).selector,
    g -> g.selector == sig:executeWithdrawOptimized(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfExecuteBorrow(method f, method g)
filtered {
    f -> f.selector == sig:executeBorrowOriginal(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams).selector,
    g -> g.selector == sig:executeBorrowOptimized(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfExecuteRepay(method f, method g)
filtered {
    f -> f.selector == sig:executeRepayOriginal(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams).selector,
    g -> g.selector == sig:executeRepayOptimized(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCumulateToLiquidityIndex(method f, method g)
filtered {
    f -> f.selector == sig:cumulateToLiquidityIndexOriginal(DataTypes.ReserveData, uint256, uint256).selector,
    g -> g.selector == sig:cumulateToLiquidityIndexOptimized(DataTypes.ReserveData, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCache(method f, method g)
filtered {
    f -> f.selector == sig:cacheOriginal(DataTypes.ReserveData).selector,
    g -> g.selector == sig:cacheOptimized(DataTypes.ReserveData).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetEmissionPerSecond(method f, method g)
filtered {
    f -> f.selector == sig:setEmissionPerSecondOriginal(address, address[], uint88[]).selector,
    g -> g.selector == sig:setEmissionPerSecondOptimized(address, address[], uint88[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfConfigureAssets(method f, method g)
filtered {
    f -> f.selector == sig:configureAssetsOriginal(RewardsDataTypes.RewardsConfigInput[]).selector,
    g -> g.selector == sig:configureAssetsOptimized(RewardsDataTypes.RewardsConfigInput[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCreateStream(method f, method g)
filtered {
    f -> f.selector == sig:createStreamOriginal(address, uint256, address, uint256, uint256).selector,
    g -> g.selector == sig:createStreamOptimized(address, uint256, address, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDeltaOf(method f, method g)
filtered {
    f -> f.selector == sig:deltaOfOriginal(uint256).selector,
    g -> g.selector == sig:deltaOfOptimized(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfWithdrawFromStream(method f, method g)
filtered {
    f -> f.selector == sig:withdrawFromStreamOriginal(uint256, uint256).selector,
    g -> g.selector == sig:withdrawFromStreamOptimized(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCancelStream(method f, method g)
filtered {
    f -> f.selector == sig:cancelStreamOriginal(uint256).selector,
    g -> g.selector == sig:cancelStreamOptimized(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}