// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

// Libraries - Optimized
import {SupplyLogic as SupplyLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/SupplyLogic.sol";
import {BorrowLogic as BorrowLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/BorrowLogic.sol";
import {ReserveLogic as ReserveLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/ReserveLogic.sol";
import {ValidationLogic as ValidationLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/ValidationLogic.sol";
import {GenericLogic as GenericLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/GenericLogic.sol";
import {CalldataLogic as CalldataLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/CalldataLogic.sol";
import {UserConfiguration as UserConfigurationOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import {MathUtils as MathUtilsOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/math/MathUtils.sol";


// Contracts - Optimized
import {Pool as PoolOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/pool/Pool.sol";
import {PoolAddressesProviderRegistry as PoolAddressesProviderRegistryOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol";
import {RewardsController as RewardsControllerOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/rewards/RewardsController.sol";
import {RewardsDistributor as RewardsDistributorOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/rewards/RewardsDistributor.sol";
import {Collector as CollectorOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/treasury/Collector.sol";

// Import DataTypes
import {DataTypes} from "./aave-v3-origin/src/contracts/protocol/libraries/types/DataTypes.sol";
import {RewardsDataTypes} from "./aave-v3-origin/src/contracts/rewards/libraries/RewardsDataTypes.sol";

contract Ao {
    
    // Contracts
    PoolOptimized public poolOptimized;
    PoolAddressesProviderRegistryOptimized public registryOptimized;
    RewardsControllerOptimized public rewardsControllerOptimized;
    RewardsDistributorOptimized public rewardsDistributorOptimized;
    CollectorOptimized public collectorOptimized;

    // State variables
    mapping(address => DataTypes.ReserveData) public reservesData;
    mapping(uint256 => address) public reservesList;
    mapping(uint8 => DataTypes.EModeCategory) public eModeCategories;
    mapping(address => DataTypes.UserConfigurationMap) public usersConfig;
    
    // SupplyLogic functions
    function executeWithdraw(
        address user,
        DataTypes.ExecuteWithdrawParams memory params
    ) external returns (uint256 amountToWithdraw) {
        DataTypes.UserConfigurationMap storage userConfig = usersConfig[user];
        return SupplyLogicOptimized.executeWithdraw(
            reservesData,
            reservesList,
            eModeCategories,
            userConfig,
            params
        );
    }
    
    function executeFinalizeTransfer(
        DataTypes.FinalizeTransferParams memory params
    ) external {
        SupplyLogicOptimized.executeFinalizeTransfer(
            reservesData,
            reservesList,
            eModeCategories,
            usersConfig,
            params
        );
    }
    
    // BorrowLogic functions
    function executeBorrow(
        address user,
        DataTypes.ExecuteBorrowParams memory params
    ) external {
        DataTypes.UserConfigurationMap storage userConfig = usersConfig[user];
        BorrowLogicOptimized.executeBorrow(
            reservesData,
            reservesList,
            eModeCategories,
            userConfig,
            params
        );
    }
    
    function executeRepay(
        address user,
        DataTypes.ExecuteRepayParams memory params
    ) external returns (uint256 paybackAmount) {
        DataTypes.UserConfigurationMap storage userConfig = usersConfig[user];
        return BorrowLogicOptimized.executeRepay(
            reservesData,
            reservesList,
            userConfig,
            params
        );
    }
    
    // ValidationLogic function
    function validateLiquidationCall(
        address user,
        address collateralAsset,
        address debtAsset,
        uint16 collateralReserveId,
        DataTypes.ValidateLiquidationCallParams memory params
    ) external view {
        DataTypes.UserConfigurationMap memory userConfig = usersConfig[user];
        DataTypes.ReserveData storage collateralReserve = reservesData[collateralAsset];
        DataTypes.ReserveData storage debtReserve = reservesData[debtAsset];
        DataTypes.ReserveConfigurationMap memory collateralReserveConfig = collateralReserve.configuration;
        
        ValidationLogicOptimized.validateLiquidationCall(
            userConfig,
            collateralReserveConfig,
            collateralReserveId,
            collateralReserve,
            debtReserve,
            params
        );
    }
    
    // GenericLogic functions
    function calculateUserAccountData(
        DataTypes.CalculateUserAccountDataParams memory params
    ) external view returns (
        uint256 totalCollateralInBaseCurrency,
        uint256 totalDebtInBaseCurrency,
        uint256 avgLtv,
        uint256 avgLiquidationThreshold,
        uint256 healthFactor,
        bool hasZeroLtvCollateral
    ) {
        return GenericLogicOptimized.calculateUserAccountData(
            reservesData,
            reservesList,
            eModeCategories,
            params
        );
    }
    
    function calculateAvailableBorrows(
        uint256 totalCollateralInBaseCurrency,
        uint256 totalDebtInBaseCurrency,
        uint256 ltv
    ) external pure returns (uint256 availableBorrowsInBaseCurrency) {
        return GenericLogicOptimized.calculateAvailableBorrows(
            totalCollateralInBaseCurrency,
            totalDebtInBaseCurrency,
            ltv
        );
    }
    
    // ReserveLogic function
    function cumulateToLiquidityIndex(
        address asset,
        uint256 totalLiquidity,
        uint256 amount
    ) external returns (uint256 result) {
        DataTypes.ReserveData storage reserve = reservesData[asset];
        return ReserveLogicOptimized.cumulateToLiquidityIndex(
            reserve,
            totalLiquidity,
            amount
        );
    }
    
    // CalldataLogic functions
    function decodeSupplyParams(
        bytes32 args
    ) external view returns (address addr, uint256 amount, uint16 referralCode) {
        return CalldataLogicOptimized.decodeSupplyParams(reservesList, args);
    }
    
    function decodeSupplyWithPermitParams(
        bytes32 args
    ) external view returns (address asset, uint256 amount, uint16 referralCode, uint256 deadline, uint8 permitV) {
        return CalldataLogicOptimized.decodeSupplyWithPermitParams(reservesList, args);
    }
    
    function decodeWithdrawParams(
        bytes32 args
    ) external view returns (address addr, uint256 amount) {
        return CalldataLogicOptimized.decodeWithdrawParams(reservesList, args);
    }
    
    function decodeBorrowParams(
        bytes32 args
    ) external view returns (address addr, uint256 amount, uint256 interestRateMode, uint16 referralCode) {
        return CalldataLogicOptimized.decodeBorrowParams(reservesList, args);
    }
    
    function decodeRepayParams(
        bytes32 args
    ) external view returns (address addr, uint256 amount, uint256 interestRateMode) {
        return CalldataLogicOptimized.decodeRepayParams(reservesList, args);
    }
    
    function decodeRepayWithPermitParams(
        bytes32 args
    ) external view returns (address asset, uint256 amount, uint256 interestRateMode, uint256 deadline, uint8 permitV) {
        return CalldataLogicOptimized.decodeRepayWithPermitParams(reservesList, args);
    }
    
    function decodeSetUserUseReserveAsCollateralParams(
        bytes32 args
    ) external view returns (address addr, bool useAsCollateral) {
        return CalldataLogicOptimized.decodeSetUserUseReserveAsCollateralParams(reservesList, args);
    }
    
    function decodeLiquidationCallParams(
        bytes32 args1,
        bytes32 args2
    ) external view returns (address colAddr, address debtAddr, address user, uint256 debtToCover, bool receiveAToken) {
        return CalldataLogicOptimized.decodeLiquidationCallParams(reservesList, args1, args2);
    }
    
    // MathUtils function
    function calculateLinearInterest(
        uint256 rate,
        uint40 lastUpdateTimestamp
    ) external view returns (uint256 result) {
        return MathUtilsOptimized.calculateLinearInterest(rate, lastUpdateTimestamp);
    }
    
    // UserConfiguration new memory functions
    function setUsingAsCollateralInMemory(
        address user,
        uint256 reserveIndex,
        bool usingAsCollateral
    ) external view returns (DataTypes.UserConfigurationMap memory) {
        DataTypes.UserConfigurationMap memory userConfig = usersConfig[user];
        UserConfigurationOptimized.setUsingAsCollateralInMemory(
            userConfig,
            reserveIndex,
            usingAsCollateral
        );
        return userConfig;
    }
    
    function setBorrowingInMemory(
        address user,
        uint256 reserveIndex,
        bool borrowing
    ) external view returns (DataTypes.UserConfigurationMap memory) {
        DataTypes.UserConfigurationMap memory userConfig = usersConfig[user];
        UserConfigurationOptimized.setBorrowingInMemory(
            userConfig,
            reserveIndex,
            borrowing
        );
        return userConfig;
    }
}
