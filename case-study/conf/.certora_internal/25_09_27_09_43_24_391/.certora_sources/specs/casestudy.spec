using A as aao;

methods {
    // SupplyLogic methods accessed through CentralUnit
    function executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams) external returns (uint256) => aao.supplyLogic.executeWithdraw(calldataarg);
    function executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams) external returns (uint256) => aao.supplyLogicOptimized.executeWithdraw(calldataarg);
    
    // BorrowLogic methods accessed through CentralUnit
    function executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams) external => aao.borrowLogic.executeBorrow(calldataarg);
    function executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams) external => aao.borrowLogicOptimized.executeBorrow(calldataarg);
    
    function executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams) external returns (uint256) => aao.borrowLogic.executeRepay(calldataarg);
    function executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams) external returns (uint256) => aao.borrowLogicOptimized.executeRepay(calldataarg);
    
    // ReserveLogic methods accessed through CentralUnit
    function cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256) external returns (uint256) => aao.reserveLogic.cumulateToLiquidityIndex(calldataarg);
    function cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256) external returns (uint256) => aao.reserveLogicOptimized.cumulateToLiquidityIndex(calldataarg);
    
    function cache(DataTypes.ReserveData) external returns (DataTypes.ReserveCache) => aao.reserveLogic.cache(calldataarg);
    function cache(DataTypes.ReserveData) external returns (DataTypes.ReserveCache) => aao.reserveLogicOptimized.cache(calldataarg);
    
    // UserConfiguration methods accessed through CentralUnit
    function setUsingAsCollateral(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfiguration.setUsingAsCollateral(calldataarg);
    function setUsingAsCollateral(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfigurationOptimized.setUsingAsCollateral(calldataarg);
    
    function setBorrowing(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfiguration.setBorrowing(calldataarg);
    function setBorrowing(DataTypes.UserConfigurationMap, uint256, bool) external => aao.userConfigurationOptimized.setBorrowing(calldataarg);
    
    function isUsingAsCollateral(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfiguration.isUsingAsCollateral(calldataarg);
    function isUsingAsCollateral(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfigurationOptimized.isUsingAsCollateral(calldataarg);
    
    function isBorrowing(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfiguration.isBorrowing(calldataarg);
    function isBorrowing(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree => aao.userConfigurationOptimized.isBorrowing(calldataarg);
    
    // RewardsDistributor methods accessed through CentralUnit
    function setEmissionPerSecond(address, address[], uint88[]) external => aao.rewardsDistributor.setEmissionPerSecond(calldataarg);
    function setEmissionPerSecond(address, address[], uint88[]) external => aao.rewardsDistributorOptimized.setEmissionPerSecond(calldataarg);
    
    function configureAssets(RewardsDataTypes.RewardsConfigInput[]) internal => aao.rewardsDistributor._configureAssets(calldataarg);
    function configureAssets(RewardsDataTypes.RewardsConfigInput[]) internal => aao.rewardsDistributorOptimized._configureAssets(calldataarg);
    
    function getDistributionEnd(address, address) external returns (uint256) envfree => aao.rewardsDistributor.getDistributionEnd(calldataarg);
    function getDistributionEnd(address, address) external returns (uint256) envfree => aao.rewardsDistributorOptimized.getDistributionEnd(calldataarg);
    
    function getRewardsByAsset(address) external returns (address[]) envfree => aao.rewardsDistributor.getRewardsByAsset(calldataarg);
    function getRewardsByAsset(address) external returns (address[]) envfree => aao.rewardsDistributorOptimized.getRewardsByAsset(calldataarg);
    
    // Collector methods accessed through CentralUnit
    function createStream(address, uint256, address, uint256, uint256) external returns (uint256) => aao.collector.createStream(calldataarg);
    function createStream(address, uint256, address, uint256, uint256) external returns (uint256) => aao.collectorOptimized.createStream(calldataarg);
    
    function deltaOf(uint256) external returns (uint256) => aao.collector.deltaOf(calldataarg);
    function deltaOf(uint256) external returns (uint256) => aao.collectorOptimized.deltaOf(calldataarg);
    
    function withdrawFromStream(uint256, uint256) external returns (bool) => aao.collector.withdrawFromStream(calldataarg);
    function withdrawFromStream(uint256, uint256) external returns (bool) => aao.collectorOptimized.withdrawFromStream(calldataarg);
    
    function cancelStream(uint256) external returns (bool) => aao.collector.cancelStream(calldataarg);
    function cancelStream(uint256) external returns (bool) => aao.collectorOptimized.cancelStream(calldataarg);
    
    function getNextStreamId() external returns (uint256) envfree => aao.collector.getNextStreamId();
    function getNextStreamId() external returns (uint256) envfree => aao.collectorOptimized.getNextStreamId();
    
    function getStream(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree => aao.collector.getStream(calldataarg);
    function getStream(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree => aao.collectorOptimized.getStream(calldataarg);
}

function executeWithdrawSummary(env e) returns uint256 {
    uint256 result;
    return result;
}

function executeBorrowSummary(env e) returns bool {
    return true;
}

function executeRepaySummary(env e) returns uint256 {
    uint256 result;
    return result;
}

// Ghost variables para estado completo
ghost mapping(address => uint256) userConfigData_original;
ghost mapping(address => uint256) userConfigData_optimized;

ghost uint128 liquidityIndex_original;
ghost uint128 liquidityIndex_optimized;
ghost uint128 variableBorrowIndex_original;
ghost uint128 variableBorrowIndex_optimized;

ghost mapping(address => mapping(address => uint256)) rewardDistributionEnd_original;
ghost mapping(address => mapping(address => uint256)) rewardDistributionEnd_optimized;

ghost mapping(address => mapping(address => uint88)) rewardEmissionPerSecond_original;
ghost mapping(address => mapping(address => uint88)) rewardEmissionPerSecond_optimized;

ghost uint256 nextStreamId_original;
ghost uint256 nextStreamId_optimized;

ghost mapping(uint256 => uint256) streamDeposit_original;
ghost mapping(uint256 => uint256) streamDeposit_optimized;

ghost mapping(address => uint256) addressProviderId_original;
ghost mapping(address => uint256) addressProviderId_optimized;

definition couplingInv() returns bool =
    // UserConfiguration state
    (forall address user. forall uint256 reserveId.
        userConfigData_original[user] == userConfigData_optimized[user]
    ) &&
    
    // ReserveLogic indices
    liquidityIndex_original == liquidityIndex_optimized &&
    variableBorrowIndex_original == variableBorrowIndex_optimized &&
    
    // RewardsDistributor state
    (forall address asset. forall address reward.
        aao.rewardsDistributor.getDistributionEnd(asset, reward) == 
        aao.rewardsDistributorOptimized.getDistributionEnd(asset, reward) &&
        rewardDistributionEnd_original[asset][reward] == 
        rewardDistributionEnd_optimized[asset][reward] &&
        rewardEmissionPerSecond_original[asset][reward] == 
        rewardEmissionPerSecond_optimized[asset][reward]
    ) &&
    
    // Collector state
    aao.collector.getNextStreamId() == aao.collectorOptimized.getNextStreamId() &&
    nextStreamId_original == nextStreamId_optimized &&
    (forall uint256 streamId.
        aao.collector.getStream(streamId) == aao.collectorOptimized.getStream(streamId) &&
        streamDeposit_original[streamId] == streamDeposit_optimized[streamId]
    ) &&
    
    // Registry state
    (forall address provider.
        aao.registry.getAddressesProviderIdByAddress(provider) == 
        aao.registryOptimized.getAddressesProviderIdByAddress(provider) &&
        addressProviderId_original[provider] == addressProviderId_optimized[provider]
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
    f -> f.selector == sig:executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams).selector,
    g -> g.selector == sig:executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfExecuteBorrow(method f, method g)
filtered {
    f -> f.selector == sig:executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams).selector,
    g -> g.selector == sig:executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfExecuteRepay(method f, method g)
filtered {
    f -> f.selector == sig:executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams).selector,
    g -> g.selector == sig:executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCumulateToLiquidityIndex(method f, method g)
filtered {
    f -> f.selector == sig:cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256).selector,
    g -> g.selector == sig:cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCache(method f, method g)
filtered {
    f -> f.selector == sig:cache(DataTypes.ReserveData).selector,
    g -> g.selector == sig:cache(DataTypes.ReserveData).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetEmissionPerSecond(method f, method g)
filtered {
    f -> f.selector == sig:setEmissionPerSecond(address, address[], uint88[]).selector,
    g -> g.selector == sig:setEmissionPerSecond(address, address[], uint88[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfConfigureAssets(method f, method g)
filtered {
    f -> f.selector == sig:configureAssets(RewardsDataTypes.RewardsConfigInput[]).selector,
    g -> g.selector == sig:configureAssets(RewardsDataTypes.RewardsConfigInput[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCreateStream(method f, method g)
filtered {
    f -> f.selector == sig:createStream(address, uint256, address, uint256, uint256).selector,
    g -> g.selector == sig:createStream(address, uint256, address, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDeltaOf(method f, method g)
filtered {
    f -> f.selector == sig:deltaOf(uint256).selector,
    g -> g.selector == sig:deltaOf(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfWithdrawFromStream(method f, method g)
filtered {
    f -> f.selector == sig:withdrawFromStream(uint256, uint256).selector,
    g -> g.selector == sig:withdrawFromStream(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCancelStream(method f, method g)
filtered {
    f -> f.selector == sig:cancelStream(uint256).selector,
    g -> g.selector == sig:cancelStream(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}