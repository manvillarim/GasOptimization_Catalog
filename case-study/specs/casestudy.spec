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
    function uco.setUsingAsCollateralInMemory(DataTypes.UserConfigurationMap, uint256, bool) external;
    
    function uc.setBorrowing(DataTypes.UserConfigurationMap, uint256, bool) external;
    function uco.setBorrowingInMemory(DataTypes.UserConfigurationMap, uint256, bool) external;
    
    // RewardsDistributor methods
    function rd.setEmissionPerSecond(address, address[], uint88[]) external;
    function rdo.setEmissionPerSecond(address, address[], uint88[]) external;
    
    function rd._configureAssets(RewardsDataTypes.RewardsConfigInput[]) external;
    function rdo._configureAssets(RewardsDataTypes.RewardsConfigInput[]) external;
    
    // Collector methods
    function c.createStream(address, uint256, address, uint256, uint256) external returns (uint256);
    function co.createStream(address, uint256, address, uint256, uint256) external returns (uint256);
    
    function c.deltaOf(uint256) external returns (uint256);
    function co.deltaOf(uint256) external returns (uint256);
    
    function c.withdrawFromStream(uint256, uint256) external returns (bool);
    function co.withdrawFromStream(uint256, uint256) external returns (bool);
    
    function c.cancelStream(uint256) external returns (bool);
    function co.cancelStream(uint256) external returns (bool);
    
    // State getters - todos os necessários
    function sl._usersConfig(address).data external returns (uint256) envfree;
    function slo._usersConfig(address).data external returns (uint256) envfree;
    
    function bl._usersConfig(address).data external returns (uint256) envfree;
    function blo._usersConfig(address).data external returns (uint256) envfree;
    
    function rl.liquidityIndex() external returns (uint128) envfree;
    function rlo.liquidityIndex() external returns (uint128) envfree;
    
    function rl.variableBorrowIndex() external returns (uint128) envfree;
    function rlo.variableBorrowIndex() external returns (uint128) envfree;
    
    function rd._assets(address).rewards(address).distributionEnd external returns (uint32) envfree;
    function rdo._assets(address).rewards(address).distributionEnd external returns (uint32) envfree;
    
    function rd._assets(address).rewards(address).emissionPerSecond external returns (uint88) envfree;
    function rdo._assets(address).rewards(address).emissionPerSecond external returns (uint88) envfree;
    
    function rd._assets(address).availableRewardsCount external returns (uint128) envfree;
    function rdo._assets(address).availableRewardsCount external returns (uint128) envfree;
    
    function c._nextStreamId() external returns (uint256) envfree;
    function co._nextStreamId() external returns (uint256) envfree;
    
    function c._streams(uint256).deposit external returns (uint256) envfree;
    function co._streams(uint256).deposit external returns (uint256) envfree;
    
    function c._streams(uint256).remainingBalance external returns (uint256) envfree;
    function co._streams(uint256).remainingBalance external returns (uint256) envfree;
    
    function c._streams(uint256).startTime external returns (uint256) envfree;
    function co._streams(uint256).startTime external returns (uint256) envfree;
    
    function c._streams(uint256).stopTime external returns (uint256) envfree;
    function co._streams(uint256).stopTime external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    // UserConfiguration state em SupplyLogic e BorrowLogic
    (forall address user. 
        sl._usersConfig(user).data == slo._usersConfig(user).data &&
        bl._usersConfig(user).data == blo._usersConfig(user).data
    ) &&
    
    // ReserveLogic state
    rl.liquidityIndex() == rlo.liquidityIndex() &&
    rl.variableBorrowIndex() == rlo.variableBorrowIndex() &&
    
    // RewardsDistributor state
    (forall address asset. forall address reward.
        rd._assets(asset).rewards(reward).distributionEnd == rdo._assets(asset).rewards(reward).distributionEnd &&
        rd._assets(asset).rewards(reward).emissionPerSecond == rdo._assets(asset).rewards(reward).emissionPerSecond
    ) &&
    (forall address asset.
        rd._assets(asset).availableRewardsCount == rdo._assets(asset).availableRewardsCount
    ) &&
    
    // Collector state completo
    c._nextStreamId() == co._nextStreamId() &&
    (forall uint256 streamId.
        c._streams(streamId).deposit == co._streams(streamId).deposit &&
        c._streams(streamId).remainingBalance == co._streams(streamId).remainingBalance &&
        c._streams(streamId).startTime == co._streams(streamId).startTime &&
        c._streams(streamId).stopTime == co._streams(streamId).stopTime
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

// Rules para todas as funções identificadas

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