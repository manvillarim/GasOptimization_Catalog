using SupplyLogic as sl;
using BorrowLogic as bl;
using ReserveLogic as rl;
using UserConfiguration as uc;
using RewardsDistributor as rd;
using Collector as c;

using SupplyLogic as slo;
using BorrowLogic as blo;
using ReserveLogic as rlo;
using UserConfiguration as uco;
using RewardsDistributor as rdo;
using Collector as co;

methods {
    // SupplyLogic methods
    function sl.executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams) external returns (uint256);
    function slo.executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams) external returns (uint256);
    
    // BorrowLogic methods  
    function bl.executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams) external;
    function blo.executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams) external;
    
    function bl.executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams) external returns (uint256);
    function blo.executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams) external returns (uint256);
    
    // ReserveLogic methods
    function rl.cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256) external returns (uint256);
    function rlo.cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256) external returns (uint256);
    
    function rl.cache(DataTypes.ReserveData) external returns (DataTypes.ReserveCache);
    function rlo.cache(DataTypes.ReserveData) external returns (DataTypes.ReserveCache);
    
    // UserConfiguration methods
    function uc.setUsingAsCollateral(DataTypes.UserConfigurationMap, uint256, bool) external;
    function uco.setUsingAsCollateral(DataTypes.UserConfigurationMap, uint256, bool) external;
    
    function uc.setBorrowing(DataTypes.UserConfigurationMap, uint256, bool) external;
    function uco.setBorrowing(DataTypes.UserConfigurationMap, uint256, bool) external;
    
    function uc.isUsingAsCollateral(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree;
    function uco.isUsingAsCollateral(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree;
    
    function uc.isBorrowing(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree;
    function uco.isBorrowing(DataTypes.UserConfigurationMap, uint256) external returns (bool) envfree;
    
    // RewardsDistributor methods
    function rd.setEmissionPerSecond(address, address[], uint88[]) external;
    function rdo.setEmissionPerSecond(address, address[], uint88[]) external;
    
    function rd._configureAssets(RewardsDataTypes.RewardsConfigInput[]) internal;
    function rdo._configureAssets(RewardsDataTypes.RewardsConfigInput[]) internal;
    
    function rd.getDistributionEnd(address, address) external returns (uint256) envfree;
    function rdo.getDistributionEnd(address, address) external returns (uint256) envfree;
    
    function rd.getRewardsByAsset(address) external returns (address[]) envfree;
    function rdo.getRewardsByAsset(address) external returns (address[]) envfree;
    
    // Collector methods
    function c.createStream(address, uint256, address, uint256, uint256) external returns (uint256);
    function co.createStream(address, uint256, address, uint256, uint256) external returns (uint256);
    
    function c.deltaOf(uint256) external returns (uint256);
    function co.deltaOf(uint256) external returns (uint256);
    
    function c.withdrawFromStream(uint256, uint256) external returns (bool);
    function co.withdrawFromStream(uint256, uint256) external returns (bool);
    
    function c.cancelStream(uint256) external returns (bool);
    function co.cancelStream(uint256) external returns (bool);
    
    function c.getNextStreamId() external returns (uint256) envfree;
    function co.getNextStreamId() external returns (uint256) envfree;
    
    function c.getStream(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree;
    function co.getStream(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree;
}

// Ghost variables para estado interno
ghost mapping(address => mapping(uint256 => bool)) userConfigCollateral_sl;
ghost mapping(address => mapping(uint256 => bool)) userConfigCollateral_slo;
ghost mapping(address => mapping(uint256 => bool)) userConfigBorrowing_bl;
ghost mapping(address => mapping(uint256 => bool)) userConfigBorrowing_blo;
ghost uint128 liquidityIndex_rl;
ghost uint128 liquidityIndex_rlo;
ghost uint128 variableBorrowIndex_rl;
ghost uint128 variableBorrowIndex_rlo;
ghost mapping(address => mapping(address => uint256)) rewardDistributionEnd_rd;
ghost mapping(address => mapping(address => uint256)) rewardDistributionEnd_rdo;
ghost mapping(address => mapping(address => uint88)) rewardEmissionPerSecond_rd;
ghost mapping(address => mapping(address => uint88)) rewardEmissionPerSecond_rdo;

definition couplingInv() returns bool =
    // UserConfiguration state
    (forall address user. forall uint256 reserveId.
        userConfigCollateral_sl[user][reserveId] == userConfigCollateral_slo[user][reserveId] &&
        userConfigBorrowing_bl[user][reserveId] == userConfigBorrowing_blo[user][reserveId]
    ) &&
    
    // ReserveLogic state
    liquidityIndex_rl == liquidityIndex_rlo &&
    variableBorrowIndex_rl == variableBorrowIndex_rlo &&
    
    // RewardsDistributor state
    (forall address asset. forall address reward.
        rd.getDistributionEnd(asset, reward) == rdo.getDistributionEnd(asset, reward) &&
        rewardDistributionEnd_rd[asset][reward] == rewardDistributionEnd_rdo[asset][reward] &&
        rewardEmissionPerSecond_rd[asset][reward] == rewardEmissionPerSecond_rdo[asset][reward]
    ) &&
    
    // Collector state
    c.getNextStreamId() == co.getNextStreamId() &&
    (forall uint256 streamId.
        c.getStream(streamId) == co.getStream(streamId)
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
    f -> f.selector == sig:sl.executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams).selector,
    g -> g.selector == sig:slo.executeWithdraw(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteWithdrawParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfExecuteBorrow(method f, method g)
filtered {
    f -> f.selector == sig:bl.executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams).selector,
    g -> g.selector == sig:blo.executeBorrow(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), mapping(uint8 => DataTypes.EModeCategory), DataTypes.UserConfigurationMap, DataTypes.ExecuteBorrowParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfExecuteRepay(method f, method g)
filtered {
    f -> f.selector == sig:bl.executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams).selector,
    g -> g.selector == sig:blo.executeRepay(mapping(address => DataTypes.ReserveData), mapping(uint256 => address), DataTypes.UserConfigurationMap, DataTypes.ExecuteRepayParams).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCumulateToLiquidityIndex(method f, method g)
filtered {
    f -> f.selector == sig:rl.cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256).selector,
    g -> g.selector == sig:rlo.cumulateToLiquidityIndex(DataTypes.ReserveData, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCache(method f, method g)
filtered {
    f -> f.selector == sig:rl.cache(DataTypes.ReserveData).selector,
    g -> g.selector == sig:rlo.cache(DataTypes.ReserveData).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetEmissionPerSecond(method f, method g)
filtered {
    f -> f.selector == sig:rd.setEmissionPerSecond(address, address[], uint88[]).selector,
    g -> g.selector == sig:rdo.setEmissionPerSecond(address, address[], uint88[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfConfigureAssets(method f, method g)
filtered {
    f -> f.selector == sig:rd._configureAssets(RewardsDataTypes.RewardsConfigInput[]).selector,
    g -> g.selector == sig:rdo._configureAssets(RewardsDataTypes.RewardsConfigInput[]).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCreateStream(method f, method g)
filtered {
    f -> f.selector == sig:c.createStream(address, uint256, address, uint256, uint256).selector,
    g -> g.selector == sig:co.createStream(address, uint256, address, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDeltaOf(method f, method g)
filtered {
    f -> f.selector == sig:c.deltaOf(uint256).selector,
    g -> g.selector == sig:co.deltaOf(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfWithdrawFromStream(method f, method g)
filtered {
    f -> f.selector == sig:c.withdrawFromStream(uint256, uint256).selector,
    g -> g.selector == sig:co.withdrawFromStream(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCancelStream(method f, method g)
filtered {
    f -> f.selector == sig:c.cancelStream(uint256).selector,
    g -> g.selector == sig:co.cancelStream(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}