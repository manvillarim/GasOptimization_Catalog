// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {SupplyLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/SupplyLogic.sol";
import {SupplyLogic as SupplyLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/SupplyLogic.sol";
import {BorrowLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/BorrowLogic.sol";
import {BorrowLogic as BorrowLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/BorrowLogic.sol";
import {ReserveLogic} from "./aave-v3-origin/src/contracts/protocol/libraries/logic/ReserveLogic.sol";
import {ReserveLogic as ReserveLogicOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/logic/ReserveLogic.sol";
import {UserConfiguration} from "./aave-v3-origin/src/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import {UserConfiguration as UserConfigurationOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import {RewardsDistributor} from "./aave-v3-origin/src/contracts/rewards/RewardsDistributor.sol";
import {RewardsDistributor as RewardsDistributorOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/rewards/RewardsDistributor.sol";
import {Collector} from "./aave-v3-origin/src/contracts/treasury/Collector.sol";
import {Collector as CollectorOptimized} from "./aave-v3-origin-liquidation-gas-fixes/src/contracts/treasury/Collector.sol";

contract CentralUnit {

    // Original and Optimized Libraries    
    using SupplyLogic for *;
    using SupplyLogicOptimized for *;
    using BorrowLogic for *;
    using BorrowLogicOptimized for *;
    using ReserveLogic for *;
    using ReserveLogicOptimized for *;
    using UserConfiguration for *;
    using UserConfigurationOptimized for *;
    
    // Original and Optimized Contracts
    RewardsDistributor public rewardsDistributor;
    RewardsDistributorOptimized public rewardsDistributorOptimized;
    Collector public collector;
    CollectorOptimized public collectorOptimized;
    
}