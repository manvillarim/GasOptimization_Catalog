// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    // Storage variables that will be accessed repeatedly in loops
    uint256 public total;
    uint256 public accumulator;
    uint256 public counter;
    uint256 public sumOfSquares;
    uint256 public productTotal;
    uint256 public weightedSum;
    
    uint256[] public values;
    uint256[] public weights;
    mapping(address => uint256) public userBalances;
    address[] public users;
    
    // State variables for complex calculations
    uint256 public globalMultiplier = 2;
    uint256 public globalDivisor = 100;
    uint256 public bonusThreshold = 1000;
    
    event TotalUpdated(uint256 newTotal);
    event AccumulatorUpdated(uint256 newAccumulator);
    event CalculationComplete(string operation, uint256 result);
    
    constructor() {
        // Initialize with sample data
        for (uint256 i = 0; i < 10; i++) {
            values.push(10 + i * 5);
            weights.push(100 - i * 5);
        }
        
        // Initialize some user balances
        users.push(address(0x1));
        users.push(address(0x2));
        users.push(address(0x3));
        userBalances[address(0x1)] = 100;
        userBalances[address(0x2)] = 200;
        userBalances[address(0x3)] = 300;
    }
    
    // OPTIMIZED: Use local variable instead of repeated storage access
    function calculateTotal() external {
        uint256 length = values.length;
        uint256 localTotal = 0; // Local variable instead of storage
        
        for (uint256 i = 0; i < length; i++) {
            localTotal += values[i]; // Only memory operations
        }
        
        total = localTotal; // Single storage write at the end
        emit TotalUpdated(total);
    }
    
    // OPTIMIZED: Multiple storage variables cached locally
    function complexCalculation() external {
        uint256 length = values.length;
        uint256 localAccumulator = 0;  // Local variable
        uint256 localCounter = 0;      // Local variable
        uint256 localSumOfSquares = sumOfSquares; // Load current value to local
        
        for (uint256 i = 0; i < length; i++) {
            localAccumulator += values[i];              // Memory operation
            localCounter += 1;                           // Memory operation
            localSumOfSquares += values[i] * values[i]; // Memory operation
        }
        
        // Write back to storage once at the end
        accumulator = localAccumulator;
        counter = localCounter;
        sumOfSquares = localSumOfSquares;
        
        emit CalculationComplete("complex", accumulator);
    }
    
    // OPTIMIZED: Nested loops with local variable
    function nestedCalculation() external {
        uint256 outerLength = values.length;
        uint256 innerLength = weights.length;
        uint256 localTotal = 0; // Local variable
        
        for (uint256 i = 0; i < outerLength; i++) {
            for (uint256 j = 0; j < innerLength; j++) {
                localTotal += values[i] * weights[j] / 100; // Memory operations only
            }
        }
        
        total = localTotal; // Single storage write
        emit TotalUpdated(total);
    }
    
    // OPTIMIZED: Conditional accumulation with local variable
    function conditionalAccumulation(uint256 threshold) external {
        uint256 length = values.length;
        uint256 localAccumulator = 0; // Local variable
        
        for (uint256 i = 0; i < length; i++) {
            if (values[i] > threshold) {
                localAccumulator += values[i]; // Memory operation
            }
        }
        
        accumulator = localAccumulator; // Single storage write
        emit AccumulatorUpdated(accumulator);
    }
    
    // OPTIMIZED: Batch mapping updates with local tracking
    function distributeRewards(uint256 rewardPerUser) external {
        uint256 length = users.length;
        uint256 localTotal = total; // Load current total to local
        
        for (uint256 i = 0; i < length; i++) {
            address user = users[i];
            // Still need to update mapping in loop (can't be optimized further)
            userBalances[user] += rewardPerUser;
        }
        
        localTotal += rewardPerUser * length; // Calculate in memory
        total = localTotal; // Single storage write
        emit TotalUpdated(total);
    }
    
    // OPTIMIZED: Cache storage variables used multiple times
    function calculateWeightedSum() external {
        uint256 length = values.length;
        uint256 localWeightedSum = 0; // Local variable
        uint256 localMultiplier = globalMultiplier;   // Cache storage value
        uint256 localDivisor = globalDivisor;         // Cache storage value
        uint256 localThreshold = bonusThreshold;      // Cache storage value
        
        for (uint256 i = 0; i < length; i++) {
            // Use cached values instead of storage reads
            uint256 weighted = values[i] * localMultiplier / localDivisor;
            localWeightedSum += weighted;
            
            // Bonus calculation with cached threshold
            if (localWeightedSum > localThreshold) {
                localWeightedSum += 10;
            }
        }
        
        weightedSum = localWeightedSum; // Single storage write
        emit CalculationComplete("weighted", weightedSum);
    }
    
    // OPTIMIZED: Product calculation with local variable
    function incrementalProduct() external {
        uint256 length = values.length;
        uint256 localProduct = 1; // Local variable
        
        for (uint256 i = 0; i < length; i++) {
            localProduct *= (values[i] + 1);         // Memory operation
            localProduct = localProduct % 1000000;   // Memory operation
        }
        
        productTotal = localProduct; // Single storage write
        emit CalculationComplete("product", productTotal);
    }
    
    // OPTIMIZED: Multiple storage operations with local caching
    function multiStorageOperation() external {
        uint256 length = values.length;
        uint256 localTotal = total;           // Cache storage
        uint256 localAccumulator = accumulator; // Cache storage
        uint256 localCounter = counter;       // Cache storage
        uint256 localSumOfSquares = sumOfSquares; // Cache storage
        
        for (uint256 i = 0; i < length; i++) {
            localTotal += values[i];              // Memory operation
            localAccumulator -= values[i] / 2;    // Memory operation
            localCounter++;                        // Memory operation
            
            // Complex operation with local variables
            if (localTotal > localAccumulator * 2) {
                localSumOfSquares += values[i] * values[i]; // Memory operation
            }
        }
        
        // Write all values back to storage at once
        total = localTotal;
        accumulator = localAccumulator;
        counter = localCounter;
        sumOfSquares = localSumOfSquares;
        
        emit CalculationComplete("multi", total);
    }
    
    // Helper functions (identical to contract A)
    function addValue(uint256 value) external {
        values.push(value);
    }
    
    function addWeight(uint256 weight) external {
        weights.push(weight);
    }
    
    function addUser(address user, uint256 balance) external {
        users.push(user);
        userBalances[user] = balance;
    }
    
    function getValuesLength() external view returns (uint256) {
        return values.length;
    }
    
    function getWeightsLength() external view returns (uint256) {
        return weights.length;
    }
    
    function getUsersLength() external view returns (uint256) {
        return users.length;
    }
    
    // Reset functions for testing
    function resetTotals() external {
        total = 0;
        accumulator = 0;
        counter = 0;
        sumOfSquares = 0;
        productTotal = 0;
        weightedSum = 0;
    }
}