// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    uint256[] public tokens;
    uint256[] public rewards;
    uint256[] public penalties;
    
    uint256 public limit;
    uint256 public price;
    uint256 public baseReward;
    uint256 public multiplier;
    uint256 public taxRate;
    uint256 public totalSupply;
    
    event TokensUpdated(uint256 count);
    event RewardsDistributed(uint256 count);
    event PenaltiesApplied(uint256 count);
    
    constructor(uint256 _limit, uint256 _price, uint256 _baseReward, uint256 _multiplier, uint256 _taxRate) {
        limit = _limit;
        price = _price;
        baseReward = _baseReward;
        multiplier = _multiplier;
        taxRate = _taxRate;
        totalSupply = 1000000;
    }
    
    // Initialize arrays with specific size
    function initializeArrays(uint256 size) external {
        tokens = new uint256[](size);
        rewards = new uint256[](size);
        penalties = new uint256[](size);
        
        // Initialize with base values
        for (uint256 i = 0; i < size; i++) {
            tokens[i] = 100;
            rewards[i] = 10;
            penalties[i] = 5;
        }
    }
    
    // OPTIMIZED: Computation moved outside the loop
    function distributeTokens() external {
        uint256 length = tokens.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        uint256 amount = limit * price;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,amount)}  // Computation done only once
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += amount;
        }
        emit TokensUpdated(length);
    }
    
    // OPTIMIZED: Multiple computations moved outside the loop
    function calculateRewards() external {
        uint256 length = rewards.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,length)}
        uint256 baseAmount = baseReward * multiplier;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,baseAmount)}  // Computation 1
        uint256 supplyBonus = totalSupply / 100;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,supplyBonus)}       // Computation 2
        // taxRate is already stored, will be used in the loop
        
        for (uint256 i = 0; i < length; i++) {
            rewards[i] += baseAmount;
            rewards[i] += supplyBonus;
            rewards[i] -= (rewards[i] * taxRate) / 1000;  // This still needs to be calculated as it depends on rewards[i]
        }
        emit RewardsDistributed(length);
    }
    
    // OPTIMIZED: Complex computation moved outside the loop
    function applyPenalties(uint256 penaltyFactor) external {
        uint256 length = penalties.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,length)}
        uint256 adjustment = (limit * price * penaltyFactor) / (multiplier + 1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,adjustment)}  // Complex computation done once
        
        for (uint256 i = 0; i < length; i++) {
            penalties[i] = (penalties[i] * adjustment) / 1000;
        }
        emit PenaltiesApplied(length);
    }
    
    // OPTIMIZED: Conditional computations moved outside the loop
    function updateTokensConditional(bool applyBonus) external {
        uint256 length = tokens.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,length)}
        uint256 amount;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,amount)}
        
        if (applyBonus) {
            amount = baseReward * multiplier * 2;  // Computation done once
        } else {
            amount = baseReward * multiplier;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,amount)}      // Computation done once
        }
        
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += amount;
        }
    }
    
    // OPTIMIZED: Computation moved outside the nested loop
    function processMatrix(uint256 rows, uint256 cols) external {
        uint256 incrementAmount = (limit + price) * multiplier / baseReward;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,incrementAmount)}  // Computation done once
        
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < cols; j++) {
                uint256 index = i * cols + j;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000f,index)}
                if (index < tokens.length) {
                    tokens[index] += incrementAmount;
                }
            }
        }
    }
    
    // Helper function to verify state
    function getTokensSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < tokens.length; i++) {
            sum += tokens[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000c,sum)}
        }
    }
    
    function getRewardsSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < rewards.length; i++) {
            sum += rewards[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000d,sum)}
        }
    }
    
    function getPenaltiesSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < penalties.length; i++) {
            sum += penalties[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000e,sum)}
        }
    }
    
    // Getters for arrays
    function getTokensLength() external view returns (uint256) {
        return tokens.length;
    }
    
    function getRewardsLength() external view returns (uint256) {
        return rewards.length;
    }
    
    function getPenaltiesLength() external view returns (uint256) {
        return penalties.length;
    }
}