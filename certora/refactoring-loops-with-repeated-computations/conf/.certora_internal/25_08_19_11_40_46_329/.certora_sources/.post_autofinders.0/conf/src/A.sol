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
    
    // Loop com computação repetida: limit * price
    function distributeTokens() external {
        uint256 length = tokens.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        for (uint256 i = 0; i < length; i++) {
            tokens[i] += limit * price;  // Computação repetida a cada iteração
        }
        emit TokensUpdated(length);
    }
    
    // Loop com múltiplas computações repetidas
    function calculateRewards() external {
        uint256 length = rewards.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,length)}
        for (uint256 i = 0; i < length; i++) {
            // Três computações repetidas a cada iteração
            rewards[i] += baseReward * multiplier;
            rewards[i] += (totalSupply / 100);
            rewards[i] -= (rewards[i] * taxRate) / 1000;
        }
        emit RewardsDistributed(length);
    }
    
    // Loop com computação complexa repetida
    function applyPenalties(uint256 penaltyFactor) external {
        uint256 length = penalties.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,length)}
        for (uint256 i = 0; i < length; i++) {
            // Computação complexa repetida
            uint256 adjustment = (limit * price * penaltyFactor) / (multiplier + 1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,adjustment)}
            penalties[i] = (penalties[i] * adjustment) / 1000;
        }
        emit PenaltiesApplied(length);
    }
    
    // Loop com computação condicional repetida
    function updateTokensConditional(bool applyBonus) external {
        uint256 length = tokens.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,length)}
        for (uint256 i = 0; i < length; i++) {
            if (applyBonus) {
                tokens[i] += (baseReward * multiplier * 2);  // Computação repetida se applyBonus for true
            } else {
                tokens[i] += (baseReward * multiplier);      // Computação repetida se applyBonus for false
            }
        }
    }
    
    // Loop aninhado com computação repetida
    function processMatrix(uint256 rows, uint256 cols) external {
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < cols; j++) {
                // Computação repetida no loop interno
                uint256 index = i * cols + j;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,index)}
                if (index < tokens.length) {
                    tokens[index] += (limit + price) * multiplier / baseReward;
                }
            }
        }
    }
    
    // Função auxiliar para verificar estado
    function getTokensSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < tokens.length; i++) {
            sum += tokens[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,sum)}
        }
    }
    
    function getRewardsSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < rewards.length; i++) {
            sum += rewards[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,sum)}
        }
    }
    
    function getPenaltiesSum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < penalties.length; i++) {
            sum += penalties[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,sum)}
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