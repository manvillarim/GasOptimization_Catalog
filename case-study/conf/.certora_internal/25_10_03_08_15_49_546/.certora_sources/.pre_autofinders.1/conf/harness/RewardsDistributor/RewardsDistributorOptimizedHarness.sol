// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {RewardsDistributor as RewardsDistributorOptimized} from "../../aave-v3-origin-liquidation-gas-fixes/src/contracts/rewards/RewardsDistributor.sol";
import {RewardsDataTypes} from "../../aave-v3-origin-liquidation-gas-fixes/src/contracts/rewards/libraries/RewardsDataTypes.sol";

/**
 * @title RewardsDistributorHarness
 * @notice Harness que HERDA de RewardsDistributor para permitir hooks do Certora
 * @dev O Certora consegue fazer hooks em contratos que herdam, não em referências
 */
contract RewardsDistributorHarness is RewardsDistributorOptimized {
    
    constructor(address emissionManager) RewardsDistributorOptimized(emissionManager) {}
    
    function _getUserAssetBalances(
        address[] calldata assets,
        address user
    ) internal pure override returns (RewardsDataTypes.UserAssetBalance[] memory userAssetBalances) {
        userAssetBalances = new RewardsDataTypes.UserAssetBalance[](assets.length);
        if(user != address(0)) {}
        return userAssetBalances;
    }
}