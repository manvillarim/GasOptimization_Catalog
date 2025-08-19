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
    
    // Inicializa arrays com tamanho específico
    function initializeArrays(uint256 size) external {
        tokens = new uint256[](size);
        rewards = new uint256[](size);
        penalties = new uint256[](size);
        
        // Inicializa com valores base
        for (uint256 i = 0; i < size; i++) {
            tokens[i] = 100;
            rewards[i] = 10;
            penalties[i] = 5;
        }
    }
    
    // OTIMIZADO: Computação movida para fora do loop
    function distributeTokens() external {
        uint256 length = tokens.length;
        uint256 amount = limit * price;  // Computação feita uma vez só
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += amount;
        }
        emit TokensUpdated(length);
    }
    
    // OTIMIZADO: Múltiplas computações movidas para fora do loop
    function calculateRewards() external {
        uint256 length = rewards.length;
        uint256 baseAmount = baseReward * multiplier;  // Computação 1
        uint256 supplyBonus = totalSupply / 100;       // Computação 2
        // taxRate já está armazenado, será usado no loop
        
        for (uint256 i = 0; i < length; i++) {
            rewards[i] += baseAmount;
            rewards[i] += supplyBonus;
            rewards[i] -= (rewards[i] * taxRate) / 1000;  // Esta ainda precisa ser calculada por depender de rewards[i]
        }
        emit RewardsDistributed(length);
    }
    
    // OTIMIZADO: Computação complexa movida para fora do loop
    function applyPenalties(uint256 penaltyFactor) external {
        uint256 length = penalties.length;
        uint256 adjustment = (limit * price * penaltyFactor) / (multiplier + 1);  // Computação complexa feita uma vez
        
        for (uint256 i = 0; i < length; i++) {
            penalties[i] = (penalties[i] * adjustment) / 1000;
        }
        emit PenaltiesApplied(length);
    }
    
    // OTIMIZADO: Computações condicionais movidas para fora do loop
    function updateTokensConditional(bool applyBonus) external {
        uint256 length = tokens.length;
        uint256 amount;
        
        if (applyBonus) {
            amount = baseReward * multiplier * 2;  // Computação feita uma vez
        } else {
            amount = baseReward * multiplier;      // Computação feita uma vez
        }
        
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += amount;
        }
    }
    
    // OTIMIZADO: Computação movida para fora do loop aninhado
    function processMatrix(uint256 rows, uint256 cols) external {
        uint256 incrementAmount = (limit + price) * multiplier / baseReward;  // Computação feita uma vez
        
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < cols; j++) {
                uint256 index = i * cols + j;
                if (index < tokens.length) {
                    tokens[index] += incrementAmount;
                }
            }
        }
    }
    
    // Função auxiliar para verificar estado
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
    
    // Getters para arrays
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