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
    // Original Aave v3 contracts
    SupplyLogic supplyLogic;
    BorrowLogic borrowLogic;
    ReserveLogic reserveLogic;
    UserConfiguration userConfiguration;
    RewardsDistributor rewardsDistributor;
    Collector collector;
    
    // Optimized versions with gas fixes
    SupplyLogicOptimized supplyLogicOptimized;
    BorrowLogicOptimized borrowLogicOptimized;
    ReserveLogicOptimized reserveLogicOptimized;
    UserConfigurationOptimized userConfigurationOptimized;
    RewardsDistributorOptimized rewardsDistributorOptimized;
    CollectorOptimized collectorOptimized;

    constructor() {

        supplyLogic = new SupplyLogic();
        borrowLogic = new BorrowLogic();
        reserveLogic = new ReserveLogic();
        userConfiguration = new UserConfiguration();
        rewardsDistributor = new RewardsDistributor();
        collector = new Collector();
        
        supplyLogicOptimized = new SupplyLogicOptimized();
        borrowLogicOptimized = new BorrowLogicOptimized();
        reserveLogicOptimized = new ReserveLogicOptimized();
        userConfigurationOptimized = new UserConfigurationOptimized();
        rewardsDistributorOptimized = new RewardsDistributorOptimized();
        collectorOptimized = new CollectorOptimized();
    }
}