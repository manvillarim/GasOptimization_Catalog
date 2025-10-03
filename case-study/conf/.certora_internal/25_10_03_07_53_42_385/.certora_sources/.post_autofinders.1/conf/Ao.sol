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
    function getUserAccruedRewards(address user, address reward) external view returns (uint256) {
        return rewardsDistributorOptimized.getUserAccruedRewards(user, reward);
    }
    
    function getAllUserRewards(address[] calldata assets, address user) external view returns (address[] memory, uint256[] memory) {
        return rewardsDistributorOptimized.getAllUserRewards(assets, user);
    }
    
    function getRewardsList() external view returns (address[] memory) {
        return rewardsDistributorOptimized.getRewardsList();
    }
    
    function getUserAssetIndex(address user, address asset, address reward) external view returns (uint256) {
        return rewardsDistributorOptimized.getUserAssetIndex(user, asset, reward);
    }
}
