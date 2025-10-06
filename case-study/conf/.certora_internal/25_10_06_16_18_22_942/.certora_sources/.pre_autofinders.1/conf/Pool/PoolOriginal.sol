// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {Pool as PoolOptimized} from "../aave-v3-origin/src/contracts/protocol/pool/Pool.sol";
import {IPoolAddressesProvider} from "../aave-v3-origin/src/contracts/interfaces/IPoolAddressesProvider.sol";

contract PoolOriginal is PoolOptimized {
    constructor(IPoolAddressesProvider provider) PoolOptimized(provider) {}

    function getRevision() internal pure virtual override returns (uint256) {
        return 0x1;
    }

    function initialize(IPoolAddressesProvider provider) external virtual override initializer {
        require(provider == ADDRESSES_PROVIDER, 'INVALID_ADDRESSES_PROVIDER');
        _flashLoanPremiumTotal = 0.0009e4;
        _flashLoanPremiumToProtocol = 0;
    }
}
