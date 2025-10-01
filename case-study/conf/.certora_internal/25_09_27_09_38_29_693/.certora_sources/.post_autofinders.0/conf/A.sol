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
    
    // RewardsController methods
    function claimAllRewardsOnBehalf(
        address[] calldata assets,
        address user,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00063000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00062000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00061001, user) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00061002, to) }
        return rewardsController.claimAllRewardsOnBehalf(assets, user, to);
    }

    function claimAllRewards(
        address[] calldata assets,
        address to
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00053000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00052000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00051001, to) }
        return rewardsController.claimAllRewards(assets, to);
    }

    function claimAllRewardsToSelf(
        address[] calldata assets
    ) public returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00073000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00072000, assets.length) }
        return rewardsController.claimAllRewardsToSelf(assets);
    }

    // RewardsDistributor methods
    function getUserAccruedRewards(address user, address reward) public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00031000, user) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00031001, reward) }
        return rewardsDistributor.getUserAccruedRewards(user, reward);
    }

    function getRewardsByAsset(address asset) public view returns (address[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00041000, asset) }
        return rewardsDistributor.getRewardsByAsset(asset);
    }

    function getRewardsList() public view returns (address[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) }
        return rewardsDistributor.getRewardsList();
    }

    function getAllUserRewards(
        address[] calldata assets,
        address user
    ) public view returns (address[] memory, uint256[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00003000, assets.offset) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00002000, assets.length) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00001001, user) }
        return rewardsDistributor.getAllUserRewards(assets, user);
    }

    /*function getPendingRewards(
        address user,
        address[] calldata rewards
    ) public view returns (uint256[] memory) {
        return rewardsDistributor.getPendingRewards(user, rewards);
    }*/

    // SupplyLogic methods

    // BorrowLogic methods

    // ReserveLogic methods

    // ValidationLogic methods

    // GenericLogic methods

    // CalldataLogic methods

    // UserConfiguration methods

    // MathUtils methods
    uint256 public rate;
    uint40 public lastUpdateTimestamp;

    function calculateLinearInterest() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) }
        return MathUtils.calculateLinearInterest(rate, lastUpdateTimestamp);
    }
}