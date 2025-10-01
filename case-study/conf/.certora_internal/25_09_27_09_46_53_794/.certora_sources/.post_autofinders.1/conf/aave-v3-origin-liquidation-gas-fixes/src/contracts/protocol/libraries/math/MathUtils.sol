// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {WadRayMath} from './WadRayMath.sol';

/**
 * @title MathUtils library
 * @author Aave
 * @notice Provides functions to perform linear and compounded interest calculations
 */
library MathUtils {
  using WadRayMath for uint256;

  /// @dev Ignoring leap years
  uint256 internal constant SECONDS_PER_YEAR = 365 days;

  /**
   * @dev Function to calculate the interest accumulated using a linear interest rate formula
   * @param rate The interest rate, in ray
   * @param lastUpdateTimestamp The timestamp of the last update of the interest
   * @return result The interest rate linearly accumulated during the timeDelta, in ray
   */
  function calculateLinearInterest(
    uint256 rate,
    uint40 lastUpdateTimestamp
  ) internal view returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00500000, 1037618708560) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00500001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00501000, rate) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00501001, lastUpdateTimestamp) }
    //solium-disable-next-line
    result = rate * (block.timestamp - uint256(lastUpdateTimestamp));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,result)}
    unchecked {
      result = result / SECONDS_PER_YEAR;
    }

    result += WadRayMath.RAY;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000c,result)}
  }

  /**
   * @dev Function to calculate the interest using a compounded interest rate formula
   * To avoid expensive exponentiation, the calculation is performed using a binomial approximation:
   *
   *  (1+x)^n = 1+n*x+[n/2*(n-1)]*x^2+[n/6*(n-1)*(n-2)*x^3...
   *
   * The approximation slightly underpays liquidity providers and undercharges borrowers, with the advantage of great
   * gas cost reductions. The whitepaper contains reference to the approximation and a table showing the margin of
   * error per different time periods
   *
   * @param rate The interest rate, in ray
   * @param lastUpdateTimestamp The timestamp of the last update of the interest
   * @return The interest rate compounded during the timeDelta, in ray
   */
  function calculateCompoundedInterest(
    uint256 rate,
    uint40 lastUpdateTimestamp,
    uint256 currentTimestamp
  ) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00510000, 1037618708561) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00510001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00511000, rate) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00511001, lastUpdateTimestamp) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00511002, currentTimestamp) }
    //solium-disable-next-line
    uint256 exp = currentTimestamp - uint256(lastUpdateTimestamp);uint256 certora_local4 = exp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,certora_local4)}

    if (exp == 0) {
      return WadRayMath.RAY;
    }

    uint256 expMinusOne;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,expMinusOne)}
    uint256 expMinusTwo;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,expMinusTwo)}
    uint256 basePowerTwo;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,basePowerTwo)}
    uint256 basePowerThree;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,basePowerThree)}
    unchecked {
      expMinusOne = exp - 1;

      expMinusTwo = exp > 2 ? exp - 2 : 0;

      basePowerTwo = rate.rayMul(rate) / (SECONDS_PER_YEAR * SECONDS_PER_YEAR);
      basePowerThree = basePowerTwo.rayMul(rate) / SECONDS_PER_YEAR;
    }

    uint256 secondTerm = exp * expMinusOne * basePowerTwo;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,secondTerm)}
    unchecked {
      secondTerm /= 2;
    }
    uint256 thirdTerm = exp * expMinusOne * expMinusTwo * basePowerThree;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,thirdTerm)}
    unchecked {
      thirdTerm /= 6;
    }

    return WadRayMath.RAY + (rate * exp) / SECONDS_PER_YEAR + secondTerm + thirdTerm;
  }

  /**
   * @dev Calculates the compounded interest between the timestamp of the last update and the current block timestamp
   * @param rate The interest rate (in ray)
   * @param lastUpdateTimestamp The timestamp from which the interest accumulation needs to be calculated
   * @return The interest rate compounded between lastUpdateTimestamp and current block timestamp, in ray
   */
  function calculateCompoundedInterest(
    uint256 rate,
    uint40 lastUpdateTimestamp
  ) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00520000, 1037618708562) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00520001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00521000, rate) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00521001, lastUpdateTimestamp) }
    return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
  }
}
