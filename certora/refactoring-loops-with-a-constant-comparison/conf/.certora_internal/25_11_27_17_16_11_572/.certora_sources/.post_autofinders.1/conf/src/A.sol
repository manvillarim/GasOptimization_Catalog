// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    uint256[] public tokens;
    uint256[] public balances;
    uint256[] public rewards;
    
    uint256 public total;
    uint256 public rewardSum;
    uint256 public balanceSum;
    uint256 public constant MIN_THRESHOLD = 10;
    uint256 public constant MAX_LIMIT = 1000000;
    bool public isActive = true;
    uint256 public baseAmount = 100;
    
    event TotalUpdated(uint256 newTotal);
    event RewardsProcessed(uint256 count);
    event BalancesUpdated(uint256 count);
    
    constructor() {
        // Initialize with default values
        for (uint256 i = 0; i < 10; i++) {
            tokens.push(50 + i * 10);
            balances.push(100 + i * 5);
            rewards.push(10 + i);
        }
    }
    
    // Loop with always-true comparison: x + i > 0 when x = 1
    function sumTokensWithConstantCheck() external {
        uint256 x = 1;
        uint256 length = tokens.length;
        total = 0;
        
        for (uint256 i = 0; i < length; i++) {
            if (x + i > 0) {  // Always true: 1 + i is always > 0
                total += tokens[i];
            }
        }
        
        emit TotalUpdated(total);
    }
    
    // Loop with multiple constant comparisons
    function processRewardsWithChecks() external {
        uint256 fixedValue = 1000;
        uint256 length = rewards.length;
        rewardSum = 0;
        
        for (uint256 i = 0; i < length; i++) {
            if (fixedValue > 500) {  // Always true: 1000 > 500
                if (MIN_THRESHOLD < 100) {  // Always true: 10 < 100
                    if (MAX_LIMIT >= 1000) {  // Always true: 1000000 >= 1000
                        rewardSum += rewards[i];
                    }
                }
            }
        }
        
        emit RewardsProcessed(length);
    }
    
    // Loop with constant state variable comparison
    function updateBalancesWithStateCheck() external {
        uint256 length = balances.length;
        balanceSum = 0;
        
        for (uint256 i = 0; i < length; i++) {
            if (isActive) {  // isActive is always true (doesn't change in the loop)
                balanceSum += balances[i];
            }
        }
        
        emit BalancesUpdated(length);
    }
    
    // Loop with complex constant comparison
    function complexConstantComparison() external view returns (uint256) {
        uint256 result = 0;
        uint256 multiplier = 2;
        uint256 divisor = 4;
        uint256 length = tokens.length;
        
        for (uint256 i = 0; i < length; i++) {
            // This comparison is always true: 2 * 5 > 4 + 3
            if (multiplier * 5 > divisor + 3) {
                result += tokens[i] * multiplier;
            }
        }
        
        return result;
    }
    
    // Nested loop with constant comparison
    function nestedLoopWithConstantCheck(uint256 rows, uint256 cols) external view returns (uint256) {
        uint256 sum = 0;
        uint256 threshold = 100;
        
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < cols; j++) {
                // threshold + 50 is always > 100 (150 > 100)
                if (threshold + 50 > 100) {
                    uint256 index = i * cols + j;
                    if (index < tokens.length) {
                        sum += tokens[index];
                    }
                }
            }
        }
        
        return sum;
    }
    
    // Loop with logical constant comparison
    function logicalConstantComparison() external view returns (uint256) {
        uint256 result = 0;
        uint256 length = rewards.length;
        bool condition1 = true;
        bool condition2 = true;
        
        for (uint256 i = 0; i < length; i++) {
            // condition1 && condition2 is always true
            if (condition1 && condition2) {
                result += rewards[i] * 2;
            }
        }
        
        return result;
    }
    
    // Loop with mathematical constant comparison
    function mathematicalConstantCheck() external view returns (uint256) {
        uint256 accumulator = 0;
        uint256 length = balances.length;
        uint256 a = 10;
        uint256 b = 20;
        uint256 c = 5;
        
        for (uint256 i = 0; i < length; i++) {
            // a + b > c is always true (30 > 5)
            if (a + b > c) {
                accumulator += balances[i];
            }
        }
        
        return accumulator;
    }
    
    // Helper functions
    function addTokens(uint256[] memory newTokens) external {
        for (uint256 i = 0; i < newTokens.length; i++) {
            tokens.push(newTokens[i]);
        }
    }
    
    function addBalances(uint256[] memory newBalances) external {
        for (uint256 i = 0; i < newBalances.length; i++) {
            balances.push(newBalances[i]);
        }
    }
    
    function addRewards(uint256[] memory newRewards) external {
        for (uint256 i = 0; i < newRewards.length; i++) {
            rewards.push(newRewards[i]);
        }
    }
    
    function getTokensLength() external view returns (uint256) {
        return tokens.length;
    }
    
    function getBalancesLength() external view returns (uint256) {
        return balances.length;
    }
    
    function getRewardsLength() external view returns (uint256) {
        return rewards.length;
    }
}