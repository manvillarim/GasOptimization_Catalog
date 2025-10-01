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
    function configureAssets(RewardsDataTypes.RewardsConfigInput[] memory config) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e0000, 1037618708542) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e1000, config) }
        rewardsControllerOptimized.configureAssets(config);
    }

    function handleAction(address user, uint256 totalSupply, uint256 userBalance) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a0000, 1037618708538) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a1000, user) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a1001, totalSupply) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a1002, userBalance) }
        rewardsControllerOptimized.handleAction(user, totalSupply, userBalance);
    }

    function claimAllRewardsOnBehalf(
        address[] calldata assets,
        address user,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f0000, 1037618708543) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f3000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f2000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f1001, user) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f1002, to) }
        return rewardsControllerOptimized.claimAllRewardsOnBehalf(assets, user, to);
    }

    function claimAllRewards(
        address[] calldata assets,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d0000, 1037618708541) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d3000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d2000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d1001, to) }
        return rewardsControllerOptimized.claimAllRewards(assets, to);
    }

    function claimAllRewardsToSelf(
        address[] calldata assets
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00400000, 1037618708544) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00400001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00403000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00402000, assets.length) }
        return rewardsControllerOptimized.claimAllRewardsToSelf(assets);
    }

    // RewardsDistributorOptimized methods
    function setEmissionPerSecond(
        address asset,
        address[] calldata rewards,
        uint88[] calldata newEmissionsPerSecond
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00380000, 1037618708536) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00380001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00381000, asset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00383001, rewards.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00382001, rewards.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00383002, newEmissionsPerSecond.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00382002, newEmissionsPerSecond.length) }
        rewardsDistributorOptimized.setEmissionPerSecond(asset, rewards, newEmissionsPerSecond);
    }

    function getUserAccruedRewards(address user, address reward) public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00390000, 1037618708537) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00390001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00391000, user) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00391001, reward) }
        return rewardsDistributorOptimized.getUserAccruedRewards(user, reward);
    }
    
    function getUserRewards(
        address[] calldata assets,
        address user,
        address reward
    ) public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c0000, 1037618708540) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c3000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c2000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c1001, user) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c1002, reward) }
        return rewardsDistributorOptimized.getUserRewards(assets, user, reward);
    }

    function getRewardsByAsset(address asset) public view returns (address[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b0000, 1037618708539) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b1000, asset) }
        return rewardsDistributorOptimized.getRewardsByAsset(asset);
    }

    function getRewardsList() public view returns (address[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00370000, 1037618708535) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00370001, 0) }
        return rewardsDistributorOptimized.getRewardsList();
    }

    function getAllUserRewards(
        address[] calldata assets,
        address user
    ) public view returns (address[] memory, uint256[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00350000, 1037618708533) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00350001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00353000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00352000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00351001, user) }
        return rewardsDistributorOptimized.getAllUserRewards(assets, user);
    }

    // SupplyLogicOptimized methods

    // BorrowLogicOptimized methods

    // ReserveLogicOptimized methods

    // ValidationLogicOptimized methods

    // GenericLogicOptimized methods

    // CalldataLogicOptimized methods

    // UserConfigurationOptimized methods

    // MathUtilsOptimized methods
    uint256 public rate;
    uint40 public lastUpdateTimestamp;

    function calculateLinearInterest() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00360000, 1037618708534) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00360001, 0) }
        return MathUtilsOptimized.calculateLinearInterest(rate, lastUpdateTimestamp);
    }
}
