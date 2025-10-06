// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {SupplyLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/SupplyLogic.sol";
import {BorrowLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/BorrowLogic.sol";
import {ReserveLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/ReserveLogic.sol";
import {ValidationLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/ValidationLogic.sol";
import {GenericLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/GenericLogic.sol";
import {CalldataLogic} from "../aave-v3-origin/src/contracts/protocol/libraries/logic/CalldataLogic.sol";
import {UserConfiguration} from "../aave-v3-origin/src/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import {MathUtils} from "../aave-v3-origin/src/contracts/protocol/libraries/math/MathUtils.sol";

import {Pool} from "../aave-v3-origin/src/contracts/protocol/pool/Pool.sol";
import {IPoolAddressesProvider} from "../aave-v3-origin/src/contracts/interfaces/IPoolAddressesProvider.sol";

contract PoolOriginal is Pool {
    constructor(IPoolAddressesProvider provider) Pool(provider) {}

    function getRevision() internal pure virtual override returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a10000, 1037618708641) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a10001, 0) }
        return 0x1;
    }

    function initialize(IPoolAddressesProvider provider) external virtual override initializer {
        require(provider == ADDRESSES_PROVIDER, 'INVALID_ADDRESSES_PROVIDER');
        _flashLoanPremiumTotal = 0.0009e4;
        _flashLoanPremiumToProtocol = 0;
    }
}
