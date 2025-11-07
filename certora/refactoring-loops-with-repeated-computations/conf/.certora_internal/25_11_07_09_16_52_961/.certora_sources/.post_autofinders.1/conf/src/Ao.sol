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
    

    function initializeArrays(uint256 size) external {
        tokens = new uint256[](size);
        rewards = new uint256[](size);
        penalties = new uint256[](size);
        
        for (uint256 i = 0; i < size; i++) {
            tokens[i] = 100;
            rewards[i] = 10;
            penalties[i] = 5;
        }
    }
    
    function distributeTokens() external {
        uint256 length = tokens.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        
        if (length > 0) {
            uint256 amount = limit * price;
            for (uint256 i = 0; i < length; i++) {
                tokens[i] += amount;
            }
        }
        
        emit TokensUpdated(length);
    }
    
    function calculateRewards() external {
        uint256 length = rewards.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,length)}
        
        if (length > 0) {
            uint256 baseAmount = baseReward * multiplier;
            uint256 supplyBonus = totalSupply / 100;
            
            for (uint256 i = 0; i < length; i++) {
                rewards[i] += baseAmount;
                rewards[i] += supplyBonus;
                rewards[i] -= (rewards[i] * taxRate) / 1000;
            }
        }
        
        emit RewardsDistributed(length);
    }
    
    function applyPenalties(uint256 penaltyFactor) external {
        uint256 length = penalties.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,length)}
        
        if (length > 0) {
            uint256 adjustment = (limit * price * penaltyFactor) / (multiplier + 1);
            
            for (uint256 i = 0; i < length; i++) {
                penalties[i] = (penalties[i] * adjustment) / 1000;
            }
        }
        
        emit PenaltiesApplied(length);
    }
    
    function updateTokensConditional(bool applyBonus) external {
        uint256 length = tokens.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,length)}

        if (length > 0) {
            uint256 amount;
            
            if (applyBonus) {
                amount = baseReward * multiplier * 2;
            } else {
                amount = baseReward * multiplier;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,amount)}
            }
            
            for (uint256 i = 0; i < length; i++) {
                tokens[i] += amount;
            }
        }
    }
    
    function processMatrix(uint256 rows, uint256 cols) external {
        
        if (rows > 0 && cols > 0) {

            uint256 incrementAmount = (limit + price) * multiplier / baseReward;
            
            for (uint256 i = 0; i < rows; i++) {
                for (uint256 j = 0; j < cols; j++) {
                    uint256 index = i * cols + j;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,index)}
                    if (index < tokens.length) {
                        tokens[index] += incrementAmount;
                    }
                }
            }
        }

    }
    
    function getTokensSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < tokens.length; i++) {
            sum += tokens[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,sum)}
        }
    }
    
    function getRewardsSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < rewards.length; i++) {
            sum += rewards[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,sum)}
        }
    }
    
    function getPenaltiesSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < penalties.length; i++) {
            sum += penalties[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,sum)}
        }
    }
    
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