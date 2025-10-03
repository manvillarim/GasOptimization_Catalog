// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {Pool} from "../aave-v3-origin-liquidation-gas-fixes/src/contracts/protocol/pool/Pool.sol";
import {IPoolAddressesProvider} from "../aave-v3-origin-liquidation-gas-fixes/src/contracts/interfaces/IPoolAddressesProvider.sol";

contract PoolOptimized is Pool {
    constructor(IPoolAddressesProvider provider) Pool(provider) {}

    function getRevision() internal pure virtual override returns (uint256) {
        return 0x2;
    }

    function initialize(IPoolAddressesProvider provider) external virtual override initializer {
        require(provider == ADDRESSES_PROVIDER, 'INVALID_ADDRESSES_PROVIDER');
        _flashLoanPremiumTotal = 0.0009e4;
        _flashLoanPremiumToProtocol = 0;
    }
}
