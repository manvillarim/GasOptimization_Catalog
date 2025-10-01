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
import {DataTypes} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/types/DataTypes.sol";
import {RewardsDataTypes} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/rewards/libraries/RewardsDataTypes.sol";

contract Ao {
    
    // Contracts
    PoolOptimized public poolOptimized;
    PoolAddressesProviderRegistryOptimized public registryOptimized;
    RewardsControllerOptimized public rewardsControllerOptimized;
    RewardsDistributorOptimized public rewardsDistributorOptimized;
    CollectorOptimized public collectorOptimized;
    
    // RewardsControllerOptimized methods
    /*function configureAssets(RewardsDataTypes.RewardsConfigInput[] memory config) public {
        rewardsControllerOptimized.configureAssets(config);
    }

    function handleAction(address user, uint256 totalSupply, uint256 userBalance) public {
        rewardsControllerOptimized.handleAction(user, totalSupply, userBalance);
    }

    function claimAllRewardsOnBehalf(
        address[] calldata assets,
        address user,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        return rewardsControllerOptimized.claimAllRewardsOnBehalf(assets, user, to);
    }

    function claimAllRewards(
        address[] calldata assets,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        return rewardsControllerOptimized.claimAllRewards(assets, to);
    }

    function claimAllRewardsToSelf(
        address[] calldata assets
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        return rewardsControllerOptimized.claimAllRewardsToSelf(assets);
    }

    // RewardsDistributorOptimized methods
    function setEmissionPerSecond(
        address asset,
        address[] calldata rewards,
        uint88[] calldata newEmissionsPerSecond
    ) public {
        rewardsDistributorOptimized.setEmissionPerSecond(asset, rewards, newEmissionsPerSecond);
    }

    function getUserAccruedRewards(address user, address reward) public view returns (uint256) {
        return rewardsDistributorOptimized.getUserAccruedRewards(user, reward);
    }
    
    function getUserRewards(
        address[] calldata assets,
        address user,
        address reward
    ) public view returns (uint256) {
        return rewardsDistributorOptimized.getUserRewards(assets, user, reward);
    }

    function getRewardsByAsset(address asset) public view returns (address[] memory) {
        return rewardsDistributorOptimized.getRewardsByAsset(asset);
    }

    function getRewardsList() public view returns (address[] memory) {
        return rewardsDistributorOptimized.getRewardsList();
    }

    function getAllUserRewards(
        address[] calldata assets,
        address user
    ) public view returns (address[] memory, uint256[] memory) {
        return rewardsDistributorOptimized.getAllUserRewards(assets, user);
    }

    // SupplyLogicOptimized methods

    // BorrowLogicOptimized methods

    // ReserveLogicOptimized methods

    // ValidationLogicOptimized methods
    /*mapping(address => DataTypes.ReserveData) public reservesData_Ao;
    mapping(uint256 => address) public reservesList_Ao;
    mapping(uint8 => DataTypes.EModeCategory) public eModeCategories_Ao;
    DataTypes.UserConfigurationMap public userConfig_Ao;
    address public user_Ao;
    uint8 public userEModeCategory_Ao;
    uint256 public reservesCount_Ao;
    address public oracle_Ao;

    function validateHealthFactor() public view returns (uint256 healthFactor, bool hasZeroLtvCollateral) {
        return ValidationLogicOptimized.validateHealthFactor(
            reservesData_Ao,
            reservesList_Ao,
            eModeCategories_Ao,
            userConfig_Ao,
            user_Ao,
            userEModeCategory_Ao,
            reservesCount_Ao,
            oracle_Ao
        );
    }*/
    // GenericLogicOptimized methods

    // CalldataLogicOptimized methods

    // UserConfigurationOptimized methods

    // MathUtilsOptimized methods
   /* uint256 public rate;
    uint40 public lastUpdateTimestamp;

    function calculateLinearInterest() public view returns (uint256) {
        return MathUtilsOptimized.calculateLinearInterest(rate, lastUpdateTimestamp);
    }*/
}
