// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
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
    
    // Loop with repeated computation: limit * price
    function distributeTokens() external {
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += limit * price;  // Repeated computation at each iteration
        }
        emit TokensUpdated(length);
    }
    
    // Loop with multiple repeated computations
    function calculateRewards() external {
        uint256 length = rewards.length;
        for (uint256 i = 0; i < length; i++) {
            // Three repeated computations at each iteration
            rewards[i] += baseReward * multiplier;
            rewards[i] += (totalSupply / 100);
            rewards[i] -= (rewards[i] * taxRate) / 1000;
        }
        emit RewardsDistributed(length);
    }
    
    // Loop with complex repeated computation
    function applyPenalties(uint256 penaltyFactor) external {
        uint256 length = penalties.length;
        for (uint256 i = 0; i < length; i++) {
            // Complex repeated computation
            uint256 adjustment = (limit * price * penaltyFactor) / (multiplier + 1);
            penalties[i] = (penalties[i] * adjustment) / 1000;
        }
        emit PenaltiesApplied(length);
    }
    
    // Loop with conditional repeated computation
    function updateTokensConditional(bool applyBonus) external {
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i++) {
            if (applyBonus) {
                tokens[i] += (baseReward * multiplier * 2);  // Repeated computation if applyBonus is true
            } else {
                tokens[i] += (baseReward * multiplier);      // Repeated computation if applyBonus is false
            }
        }
    }
    
    // Nested loop with repeated computation
    function processMatrix(uint256 rows, uint256 cols) external {
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < cols; j++) {
                // Repeated computation in inner loop
                uint256 index = i * cols + j;
                if (index < tokens.length) {
                    tokens[index] += (limit + price) * multiplier / baseReward;
                }
            }
        }
    }
    
    // Helper function to verify state
    function getTokensSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < tokens.length; i++) {
            sum += tokens[i];
        }
    }
    
    function getRewardsSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < rewards.length; i++) {
            sum += rewards[i];
        }
    }
    
    function getPenaltiesSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < penalties.length; i++) {
            sum += penalties[i];
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