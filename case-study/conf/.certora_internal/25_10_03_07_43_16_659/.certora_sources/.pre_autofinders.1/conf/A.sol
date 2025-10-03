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
    
}