// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

// Libraries - Originals
import {SupplyLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/SupplyLogic.sol";
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
    
    /// RewardsController methods
    function getUserAccruedRewards(address user, address reward) external view returns (uint256) {
        return rewardsDistributor.getUserAccruedRewards(user, reward);
    }
    
    function getAllUserRewards(address[] calldata assets, address user) external view returns (address[] memory, uint256[] memory) {
        return rewardsDistributor.getAllUserRewards(assets, user);
    }
    
    function getRewardsList() external view returns (address[] memory) {
        return rewardsDistributor.getRewardsList();
    }
    
    function getUserAssetIndex(address user, address asset, address reward) external view returns (uint256) {
        return rewardsDistributor.getUserAssetIndex(user, asset, reward);
    }
    /*function configureAssets(RewardsDataTypes.RewardsConfigInput[] memory config) public {
        rewardsController.configureAssets(config);
    }

    function handleAction(address user, uint256 totalSupply, uint256 userBalance) public {
        rewardsController.handleAction(user, totalSupply, userBalance);
    }

    function claimAllRewardsOnBehalf(
        address[] calldata assets,
        address user,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        return rewardsController.claimAllRewardsOnBehalf(assets, user, to);
    }

    function claimAllRewards(
        address[] calldata assets,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        return rewardsController.claimAllRewards(assets, to);
    }

    function claimAllRewardsToSelf(
        address[] calldata assets
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        return rewardsController.claimAllRewardsToSelf(assets);
    }

    // RewardsDistributor methods
    function setEmissionPerSecond(
        address asset,
        address[] calldata rewards,
        uint88[] calldata newEmissionsPerSecond
    ) public {
        rewardsDistributor.setEmissionPerSecond(asset, rewards, newEmissionsPerSecond);
    }

    function getUserAccruedRewards(address user, address reward) public view returns (uint256) {
        return rewardsDistributor.getUserAccruedRewards(user, reward);
    }
    
    function getUserRewards(
        address[] calldata assets,
        address user,
        address reward
    ) public view returns (uint256) {
        return rewardsDistributor.getUserRewards(assets, user, reward);
    }

    function getRewardsByAsset(address asset) public view returns (address[] memory) {
        return rewardsDistributor.getRewardsByAsset(asset);
    }

    function getRewardsList() public view returns (address[] memory) {
        return rewardsDistributor.getRewardsList();
    }

    function getAllUserRewards(
        address[] calldata assets,
        address user
    ) public view returns (address[] memory, uint256[] memory) {
        return rewardsDistributor.getAllUserRewards(assets, user);
    }

    // SupplyLogic methods

    // BorrowLogic methods

    // ReserveLogic methods

    // ValidationLogic methods
    mapping(address => DataTypes.ReserveData) public reservesData_A;
    mapping(uint256 => address) public reservesList_A;
    mapping(uint8 => DataTypes.EModeCategory) public eModeCategories_A;
    DataTypes.UserConfigurationMap public userConfig_A;
    address public user_A;
    uint8 public userEModeCategory_A;
    uint256 public reservesCount_A;
    address public oracle_A;

    function validateHealthFactor() public view returns (uint256 healthFactor, bool hasZeroLtvCollateral) {
        return ValidationLogic.validateHealthFactor(
            reservesData_A,
            reservesList_A,
            eModeCategories_A,
            userConfig_A,
            user_A,
            userEModeCategory_A,
            reservesCount_A,
            oracle_A
        );
    }
    // GenericLogic methods

    // CalldataLogic methods

    // UserConfiguration methods

    // MathUtils methods
    uint256 public rate;
    uint40 public lastUpdateTimestamp;

    function calculateLinearInterest() public view returns (uint256) {
        return MathUtils.calculateLinearInterest(rate, lastUpdateTimestamp);
    }*/
}