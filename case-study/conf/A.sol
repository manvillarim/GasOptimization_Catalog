// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

// Libraries - Originals
import {SupplyLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/SupplyLogic.sol";
import {BorrowLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/BorrowLogic.sol";
import {ReserveLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/ReserveLogic.sol";
import {ValidationLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/ValidationLogic.sol";
import {GenericLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/GenericLogic.sol";
import {CalldataLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/CalldataLogic.sol";
import {UserConfiguration} from "./aave-v3-origin/src/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import {MathUtils} from "./aave-v3-origin/src/contracts/protocol/libraries/math/MathUtils.sol";

// Contrats - Originals
import {Pool} from "./aave-v3-origin/src/contracts/protocol/pool/Pool.sol";
import {PoolAddressesProviderRegistry} from "./aave-v3-origin/src/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol";
import {RewardsController} from "./aave-v3-origin/src/contracts/rewards/RewardsController.sol";
import {RewardsDistributor} from "./aave-v3-origin/src/contracts/rewards/RewardsDistributor.sol";
import {Collector} from "./aave-v3-origin/src/contracts/treasury/Collector.sol";

// Import DataTypes 
import {DataTypes} from "./aave-v3-origin/src/contracts/protocol/libraries/types/DataTypes.sol";
import {RewardsDataTypes} from "./aave-v3-origin/src/contracts/rewards/libraries/RewardsDataTypes.sol";

contract A {
    
    // Contracts - Originals
    Pool public pool;
    PoolAddressesProviderRegistry public registry;
    RewardsController public rewardsController;
    RewardsDistributor public rewardsDistributor;
    Collector public collector;
    
    // State variables
    mapping(address => DataTypes.ReserveData) public reservesData;
    mapping(uint256 => address) public reservesList;
    mapping(uint8 => DataTypes.EModeCategory) public eModeCategories;
    mapping(address => DataTypes.UserConfigurationMap) public usersConfig;
    
    // SupplyLogic functions
    function executeWithdraw(
        address user,
        DataTypes.ExecuteWithdrawParams memory params
    ) external returns (uint256) {
        DataTypes.UserConfigurationMap storage userConfig = usersConfig[user];
        return SupplyLogic.executeWithdraw(
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
        SupplyLogic.executeFinalizeTransfer(
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
        BorrowLogic.executeBorrow(
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
    ) external returns (uint256) {
        DataTypes.UserConfigurationMap storage userConfig = usersConfig[user];
        return BorrowLogic.executeRepay(
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
        DataTypes.ValidateLiquidationCallParams memory params
    ) external view {
        DataTypes.UserConfigurationMap storage userConfig = usersConfig[user];
        DataTypes.ReserveData storage collateralReserve = reservesData[collateralAsset];
        DataTypes.ReserveData storage debtReserve = reservesData[debtAsset];
        
        ValidationLogic.validateLiquidationCall(
            userConfig,
            collateralReserve,
            debtReserve,
            params
        );
    }
    
    // GenericLogic functions
    function calculateUserAccountData(
        DataTypes.CalculateUserAccountDataParams memory params
    ) external view returns (uint256, uint256, uint256, uint256, uint256, bool) {
        return GenericLogic.calculateUserAccountData(
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
    ) external pure returns (uint256) {
        return GenericLogic.calculateAvailableBorrows(
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
    ) external returns (uint256) {
        DataTypes.ReserveData storage reserve = reservesData[asset];
        return ReserveLogic.cumulateToLiquidityIndex(
            reserve,
            totalLiquidity,
            amount
        );
    }
    
    // CalldataLogic functions
    function decodeSupplyParams(
        bytes32 args
    ) external view returns (address, uint256, uint16) {
        return CalldataLogic.decodeSupplyParams(reservesList, args);
    }
    
    function decodeSupplyWithPermitParams(
        bytes32 args
    ) external view returns (address, uint256, uint16, uint256, uint8) {
        return CalldataLogic.decodeSupplyWithPermitParams(reservesList, args);
    }
    
    function decodeWithdrawParams(
        bytes32 args
    ) external view returns (address, uint256) {
        return CalldataLogic.decodeWithdrawParams(reservesList, args);
    }
    
    function decodeBorrowParams(
        bytes32 args
    ) external view returns (address, uint256, uint256, uint16) {
        return CalldataLogic.decodeBorrowParams(reservesList, args);
    }
    
    function decodeRepayParams(
        bytes32 args
    ) external view returns (address, uint256, uint256) {
        return CalldataLogic.decodeRepayParams(reservesList, args);
    }
    
    function decodeRepayWithPermitParams(
        bytes32 args
    ) external view returns (address, uint256, uint256, uint256, uint8) {
        return CalldataLogic.decodeRepayWithPermitParams(reservesList, args);
    }
    
    function decodeSetUserUseReserveAsCollateralParams(
        bytes32 args
    ) external view returns (address, bool) {
        return CalldataLogic.decodeSetUserUseReserveAsCollateralParams(reservesList, args);
    }
    
    function decodeLiquidationCallParams(
        bytes32 args1,
        bytes32 args2
    ) external view returns (address, address, address, uint256, bool) {
        return CalldataLogic.decodeLiquidationCallParams(reservesList, args1, args2);
    }
    
    // MathUtils function
    function calculateLinearInterest(
        uint256 rate,
        uint40 lastUpdateTimestamp
    ) external view returns (uint256) {
        return MathUtils.calculateLinearInterest(rate, lastUpdateTimestamp);
    }
}